import java.io.FileInputStream
import java.util.Properties

// This initial block reads the keystore properties, same as in the pomozen file.
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
    // Using OpenJot's namespace
    namespace = "org.thegandabherunda.openjot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    // Compiler options and desugaring support from pomozen
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Lint options from pomozen
    lint {
        checkReleaseBuilds = false
    }

    defaultConfig {
        // Using OpenJot's application ID
        applicationId = "org.thegandabherunda.openjot"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Signing configuration remains the same
    signingConfigs {
        create("release") {
            if (keystoreProperties.isNotEmpty()) {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    // Release build type configuration from pomozen, including minification
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
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

// Custom version code logic for different ABIs, copied from pomozen
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

// Dependency for core library desugaring, from pomozen
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
