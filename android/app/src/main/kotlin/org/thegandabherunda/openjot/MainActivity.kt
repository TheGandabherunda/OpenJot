package org.thegandabherunda.openjot

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.net.Uri
import android.os.Bundle
import android.webkit.MimeTypeMap
import androidx.core.app.ActivityCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.UUID

class MainActivity : FlutterFragmentActivity() {
    private val LOCATION_CHANNEL = "foss_location"
    private val SHARE_CHANNEL = "app.channel.shared.data"
    private val REQUEST_CODE = 1001
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

                "getCurrentLocation" -> {
                    val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
                    if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                        ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                        result.error("PERMISSION_DENIED", "Location permission not granted", null)
                        return@setMethodCallHandler
                    }
                    val providers = locationManager.getProviders(true)
                    var bestLocation: Location? = null
                    for (provider in providers) {
                        val l = locationManager.getLastKnownLocation(provider)
                        if (bestLocation == null || (l != null && l.accuracy < bestLocation.accuracy)) {
                            bestLocation = l
                        }
                    }
                    if (bestLocation != null) {
                        result.success(mapOf("latitude" to bestLocation.latitude, "longitude" to bestLocation.longitude))
                    } else {
                        result.error("NO_LOCATION", "Could not fetch location", null)
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

