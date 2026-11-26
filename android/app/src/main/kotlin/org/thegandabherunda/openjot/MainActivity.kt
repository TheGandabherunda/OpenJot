package org.thegandabherunda.openjot

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.webkit.MimeTypeMap
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.security.SecureRandom
import java.util.UUID
import java.util.concurrent.Executors
import javax.crypto.AEADBadTagException
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec

class MainActivity : FlutterFragmentActivity() {
    private val LOCATION_CHANNEL = "foss_location"
    private val SHARE_CHANNEL = "app.channel.shared.data"
    private val CRYPTO_CHANNEL = "openjot/native_crypto"
    private val REQUEST_CODE = 1001
    private val cryptoExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var pendingResult: MethodChannel.Result? = null
    private var initialSharedData: Map<String, Any?>? = null
    private lateinit var shareChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Location Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCATION_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermission" -> {
                    if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) ==
                        PackageManager.PERMISSION_GRANTED) {
                        result.success(true)
                    } else {
                        pendingResult = result
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                            REQUEST_CODE
                        )
                    }
                }

                "isLocationServiceEnabled" -> {
                    val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
                    val isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                    val isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
                    result.success(isGpsEnabled || isNetworkEnabled)
                }

                "openLocationSettings" -> {
                    val intent = Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(null)
                }

                "getCurrentLocation" -> {
                    val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
                    if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                        ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                        result.success(null) // Safe return so Flutter side doesn't break
                        return@setMethodCallHandler
                    }

                    val isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                    val isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)

                    if (!isGpsEnabled && !isNetworkEnabled) {
                        result.success(null) // Safe return so Flutter side doesn't break
                        return@setMethodCallHandler
                    }

                    val providers = locationManager.getProviders(true)
                    var bestLocation: Location? = null
                    for (provider in providers) {
                        val l = locationManager.getLastKnownLocation(provider)
                        if (l != null && (bestLocation == null || l.accuracy < bestLocation!!.accuracy)) {
                            bestLocation = l
                        }
                    }

                    // If we have a cached location less than 2 minutes old, use it immediately
                    if (bestLocation != null && (System.currentTimeMillis() - bestLocation.time) < 2 * 60 * 1000) {
                        result.success(mapOf("latitude" to bestLocation.latitude, "longitude" to bestLocation.longitude))
                        return@setMethodCallHandler
                    }

                    // Prioritize NETWORK_PROVIDER. It resolves almost instantly, whereas GPS can hang a long time right after turning it on.
                    val provider = if (isNetworkEnabled) LocationManager.NETWORK_PROVIDER else LocationManager.GPS_PROVIDER

                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                        val cancellationSignal = android.os.CancellationSignal()
                        var hasResponded = false

                        val timeoutHandler = android.os.Handler(Looper.getMainLooper())
                        val timeoutRunnable = Runnable {
                            if (!hasResponded) {
                                hasResponded = true
                                cancellationSignal.cancel()
                                if (bestLocation != null) {
                                    result.success(mapOf("latitude" to bestLocation!!.latitude, "longitude" to bestLocation!!.longitude))
                                } else {
                                    // Prevents infinite loop/hang if unable to get fix
                                    result.success(null)
                                }
                            }
                        }
                        timeoutHandler.postDelayed(timeoutRunnable, 8000) // 8-second safety timeout

                        locationManager.getCurrentLocation(
                            provider,
                            cancellationSignal,
                            ContextCompat.getMainExecutor(this)
                        ) { location ->
                            if (!hasResponded) {
                                hasResponded = true
                                timeoutHandler.removeCallbacks(timeoutRunnable)
                                if (location != null) {
                                    result.success(mapOf("latitude" to location.latitude, "longitude" to location.longitude))
                                } else if (bestLocation != null) {
                                    result.success(mapOf("latitude" to bestLocation.latitude, "longitude" to bestLocation.longitude))
                                } else {
                                    result.success(null)
                                }
                            }
                        }
                    } else {
                        var hasResponded = false
                        val listener = object : android.location.LocationListener {
                            override fun onLocationChanged(location: Location) {
                                if (!hasResponded) {
                                    hasResponded = true
                                    locationManager.removeUpdates(this)
                                    result.success(mapOf("latitude" to location.latitude, "longitude" to location.longitude))
                                }
                            }
                            override fun onStatusChanged(p0: String?, p1: Int, p2: Bundle?) {}
                            override fun onProviderEnabled(p0: String) {}
                            override fun onProviderDisabled(p0: String) {}
                        }

                        val timeoutHandler = android.os.Handler(Looper.getMainLooper())
                        val timeoutRunnable = Runnable {
                            if (!hasResponded) {
                                hasResponded = true
                                locationManager.removeUpdates(listener)
                                if (bestLocation != null) {
                                    result.success(mapOf("latitude" to bestLocation!!.latitude, "longitude" to bestLocation!!.longitude))
                                } else {
                                    result.success(null)
                                }
                            }
                        }
                        timeoutHandler.postDelayed(timeoutRunnable, 8000) // 8-second safety timeout

                        @Suppress("DEPRECATION")
                        locationManager.requestSingleUpdate(
                            provider,
                            listener,
                            Looper.getMainLooper()
                        )
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Share Channel
        shareChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARE_CHANNEL)
        shareChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialShareData" -> {
                    result.success(initialSharedData)
                    initialSharedData = null
                }
                "shareContent" -> {
                    val args = call.arguments as? Map<*, *>
                    val text = args?.get("text") as? String
                    val files = args?.get("files") as? List<String>
                    shareContent(text, files)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // Background Native Crypto Channel (AES-256-GCM + PBKDF2-HMAC-SHA256)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CRYPTO_CHANNEL).setMethodCallHandler { call, result ->
            cryptoExecutor.execute {
                try {
                    when (call.method) {
                        "pbkdf2" -> {
                            val password = call.argument<String>("password")!!
                            val salt = call.argument<ByteArray>("salt")!!
                            val iterations = call.argument<Int>("iterations")!!
                            val bits = call.argument<Int>("bits")!!
                            val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                            val spec = PBEKeySpec(password.toCharArray(), salt, iterations, bits)
                            val encoded = factory.generateSecret(spec).encoded
                            mainHandler.post { result.success(encoded) }
                        }

                        "encryptBackupFile" -> {
                            val zipPath = call.argument<String>("zipPath")!!
                            val outPath = call.argument<String>("outPath")!!
                            val password = call.argument<String>("password")!!
                            val iterations = call.argument<Int>("iterations")!!
                            encryptBackupFileNative(zipPath, outPath, password, iterations)
                            mainHandler.post { result.success(null) }
                        }

                        "decryptBackupFile" -> {
                            val encPath = call.argument<String>("encPath")!!
                            val outZipPath = call.argument<String>("outZipPath")!!
                            val password = call.argument<String>("password")!!
                            decryptBackupFileNative(encPath, outZipPath, password)
                            mainHandler.post { result.success(null) }
                        }

                        else -> mainHandler.post { result.notImplemented() }
                    }
                } catch (e: AEADBadTagException) {
                    mainHandler.post { result.error("INCORRECT_PASSWORD", e.message, null) }
                } catch (e: Exception) {
                    mainHandler.post { result.error("CRYPTO_ERROR", e.message ?: e.toString(), null) }
                }
            }
        }
    }

    private fun deriveAes256Key(password: String, salt: ByteArray, iterations: Int): ByteArray {
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val spec = PBEKeySpec(password.toCharArray(), salt, iterations, 256)
        return factory.generateSecret(spec).encoded
    }

    private fun encryptBackupFileNative(
        zipPath: String,
        outPath: String,
        password: String,
        iterations: Int,
    ) {
        val rng = SecureRandom()
        val salt = ByteArray(16).also { rng.nextBytes(it) }
        val nonce = ByteArray(12).also { rng.nextBytes(it) }
        val header = ByteArray(28)
        val magic = byteArrayOf(0x4F, 0x4A, 0x45, 0x4E, 0x43, 0x30, 0x31, 0x00)
        System.arraycopy(magic, 0, header, 0, 8)
        System.arraycopy(salt, 0, header, 8, 16)
        ByteBuffer.wrap(header, 24, 4).putInt(iterations)

        val keyBytes = deriveAes256Key(password, salt, iterations)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(
            Cipher.ENCRYPT_MODE,
            SecretKeySpec(keyBytes, "AES"),
            GCMParameterSpec(128, nonce),
        )
        cipher.updateAAD(header)

        val outFile = File(outPath)
        try {
            FileInputStream(zipPath).use { input ->
                FileOutputStream(outFile).use { output ->
                    output.write(header)
                    output.write(nonce)
                    val buffer = ByteArray(65536)
                    while (true) {
                        val read = input.read(buffer)
                        if (read == -1) break
                        val chunk = cipher.update(buffer, 0, read)
                        if (chunk != null && chunk.isNotEmpty()) {
                            output.write(chunk)
                        }
                    }
                    val finalBytes = cipher.doFinal()
                    if (finalBytes != null && finalBytes.isNotEmpty()) {
                        output.write(finalBytes)
                    }
                    output.fd.sync()
                }
            }
        } catch (e: Exception) {
            if (outFile.exists()) outFile.delete()
            throw e
        } finally {
            keyBytes.fill(0)
        }
    }

    private fun decryptBackupFileNative(
        encPath: String,
        outZipPath: String,
        password: String,
    ) {
        val encFile = File(encPath)
        val fileLen = encFile.length()
        if (fileLen < 28L + 12L + 16L) {
            throw IllegalArgumentException("Encrypted backup file is too small.")
        }

        val outFile = File(outZipPath)
        var keyBytes: ByteArray? = null
        try {
            FileInputStream(encFile).use { input ->
                val header = ByteArray(28)
                val nonce = ByteArray(12)
                if (input.read(header) != 28 || input.read(nonce) != 12) {
                    throw IllegalArgumentException("Failed to read encrypted backup header.")
                }
                val magic = byteArrayOf(0x4F, 0x4A, 0x45, 0x4E, 0x43, 0x30, 0x31, 0x00)
                for (i in 0 until 8) {
                    if (header[i] != magic[i]) {
                        throw IllegalArgumentException("Invalid OpenJot encrypted backup header.")
                    }
                }
                val salt = header.copyOfRange(8, 24)
                val iterations = ByteBuffer.wrap(header, 24, 4).int
                if (iterations < 1000 || iterations > 10000000) {
                    throw IllegalArgumentException("Unsupported KDF iteration count.")
                }

                keyBytes = deriveAes256Key(password, salt, iterations)
                val cipher = Cipher.getInstance("AES/GCM/NoPadding")
                cipher.init(
                    Cipher.DECRYPT_MODE,
                    SecretKeySpec(keyBytes, "AES"),
                    GCMParameterSpec(128, nonce),
                )
                cipher.updateAAD(header)

                FileOutputStream(outFile).use { output ->
                    val buffer = ByteArray(65536)
                    while (true) {
                        val read = input.read(buffer)
                        if (read == -1) break
                        val chunk = cipher.update(buffer, 0, read)
                        if (chunk != null && chunk.isNotEmpty()) {
                            output.write(chunk)
                        }
                    }
                    val finalBytes = cipher.doFinal()
                    if (finalBytes != null && finalBytes.isNotEmpty()) {
                        output.write(finalBytes)
                    }
                    output.fd.sync()
                }
            }
        } catch (e: Exception) {
            if (outFile.exists()) outFile.delete()
            throw e
        } finally {
            keyBytes?.fill(0)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null) return

        when (intent.action) {
            Intent.ACTION_SEND, Intent.ACTION_SEND_MULTIPLE -> {
                val data = extractSharedData(intent)
                if (isFlutterEngineInitialized()) {
                    shareChannel.invokeMethod("onShareReceived", data)
                } else {
                    initialSharedData = data
                }
            }
        }
    }

    private fun extractSharedData(intent: Intent): Map<String, Any?> {
        val text = intent.getStringExtra(Intent.EXTRA_TEXT)
        val files = mutableListOf<Map<String, String>>()

        if (intent.action == Intent.ACTION_SEND) {
            intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uri ->
                copyUriToCache(uri)?.let { (path, mimeType) ->
                    files.add(mapOf("path" to path, "mimeType" to mimeType))
                }
            }
        } else if (intent.action == Intent.ACTION_SEND_MULTIPLE) {
            intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)?.forEach { uri ->
                copyUriToCache(uri)?.let { (path, mimeType) ->
                    files.add(mapOf("path" to path, "mimeType" to mimeType))
                }
            }
        }

        return mapOf("text" to text, "files" to files)
    }

    private fun copyUriToCache(uri: Uri): Pair<String, String>? {
        return try {
            val inputStream = contentResolver.openInputStream(uri)
            val mimeType = contentResolver.getType(uri) ?: "application/octet-stream"
            val fileExtension = MimeTypeMap.getSingleton().getExtensionFromMimeType(mimeType) ?: "tmp"

            val tempFile = File(cacheDir, "${UUID.randomUUID()}.$fileExtension")
            val outputStream = FileOutputStream(tempFile)

            inputStream?.copyTo(outputStream)
            inputStream?.close()
            outputStream.close()

            Pair(tempFile.absolutePath, mimeType)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun shareContent(text: String?, filePaths: List<String>?) {
        val intent = Intent()
        val hasFiles = !filePaths.isNullOrEmpty()

        if (hasFiles) {
            val uris = ArrayList<Uri>()
            filePaths!!.forEach {
                val file = File(it)
                val uri = FileProvider.getUriForFile(this, "$packageName.provider", file)
                uris.add(uri)
            }

            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

            if (uris.size > 1) {
                intent.action = Intent.ACTION_SEND_MULTIPLE
                intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
                val firstMimeType = getMimeType(filePaths.first())
                if (filePaths.all { getMimeType(it) == firstMimeType }) {
                    intent.type = firstMimeType
                } else {
                    intent.type = "*/*"
                }
            } else {
                intent.action = Intent.ACTION_SEND
                intent.putExtra(Intent.EXTRA_STREAM, uris.first())
                intent.type = getMimeType(filePaths.first()) ?: "*/*"
            }
        } else {
            intent.action = Intent.ACTION_SEND
            intent.type = "text/plain"
        }

        text?.let {
            intent.putExtra(Intent.EXTRA_TEXT, it)
            intent.putExtra(Intent.EXTRA_SUBJECT, it)
        }

        val chooser = Intent.createChooser(intent, "Share via")
        startActivity(chooser)
    }

    private fun getMimeType(path: String): String? {
        val extension = path.substringAfterLast('.', "")
        if (extension.isEmpty()) return null
        return MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension.lowercase())
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingResult?.success(granted)
            pendingResult = null
        }
    }

    private fun isFlutterEngineInitialized(): Boolean {
        return this::shareChannel.isInitialized
    }
}