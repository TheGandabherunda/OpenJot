import java.io.FileInputStream
import java.util.Properties

// --- Read keystore properties safely for F-Droid Compatibility ---
val keystoreProperties = Properties()
val keystorePropertiesFile = project.rootProject.file("key.properties")
val hasKeystore = keystorePropertiesFile.exists()

// Only attempt to load if it actually exists (F-Droid won't have it)
if (hasKeystore) {
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
    ndkVersion = "26.1.10909125"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    lint {
        checkReleaseBuilds = false
    }

    defaultConfig {
        applicationId = "org.thegandabherunda.openjot"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Explicitly enforce optimized Split APKs natively
    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a", "x86_64")
            isUniversalApk = false // Ensures it absolutely does NOT generate a bloated universal APK
        }
    }

    // Only create the release signing config if keys are physically present
    signingConfigs {
        if (hasKeystore) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    flavorDimensions += "type"
    productFlavors {
        create("foss") {
            dimension = "type"
            applicationIdSuffix = ".foss"
            versionNameSuffix = "-foss"
        }
        create("standard") {
            dimension = "type"
        }
    }

    buildTypes {
        getByName("release") {
            // F-Droid compliance: Dynamically bind or remove signing configs based on local key availability
            if (hasKeystore) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = null // Gracefully default to an unsigned build
            }
            
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}        applicationId = "org.thegandabherunda.openjot"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Explicitly configure Split APKs for the requested architectures
    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a", "x86_64")
            isUniversalApk = false // Ensures it does NOT generate a universal APK
        }
    }

    // Only create the release signing config if keys are physically present
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

    flavorDimensions += "type"
    productFlavors {
        create("foss") {
            dimension = "type"
            applicationIdSuffix = ".foss"
            versionNameSuffix = "-foss"
        }
        create("standard") {
            dimension = "type"
        }
    }

    buildTypes {
        getByName("release") {
            // Apply signing config ONLY if it was created successfully above
            if (keystorePropertiesFile.exists() && keystoreProperties.isNotEmpty()) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
