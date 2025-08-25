import java.io.FileInputStream
import java.util.Properties

// This initial block reads the keystore properties.
val keystoreProperties = Properties()
val keystorePropertiesFile = project.rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.thegandabherunda.openjot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    lint {
        checkReleaseBuilds = false
    }

    // --- FIX FOR MANIFEST BINARY DIFF ---
    aaptOptions {
        noCompress("AndroidManifest.xml")
    }

    defaultConfig {
        applicationId = "org.thegandabherunda.openjot"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // --- CORRECTED SIGNING CONFIG ---
    // The signing configuration is now created only if the keystore file exists.
    signingConfigs {
        if (keystorePropertiesFile.exists() && keystoreProperties.isNotEmpty()) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        getByName("release") {
            // This will now correctly find a valid signing config or none at all,
            // resulting in an unsigned build if key.properties is absent.
            if (signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            }

            isMinifyEnabled = true
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            dependenciesInfo {
                includeInApk = false
                includeInBundle = false
            }
        }
    }
}

flutter {
    source = "../.."
}

val abiCodes = mapOf(
    "x86_64" to 1,
    "armeabi-v7a" to 2,
    "arm64-v8a" to 3
)

androidComponents {
    onVariants { variant ->
        variant.outputs.forEach { output ->
            val abi = output.filters.find { it.filterType.name == "ABI" }?.identifier
            val baseVersionCode = flutter.versionCode
            val abiCode = abiCodes[abi]
            if (abiCode != null) {
                output.versionCode.set(baseVersionCode * 10 + abiCode)
            } else {
                output.versionCode.set(flutter.versionCode)
            }
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
