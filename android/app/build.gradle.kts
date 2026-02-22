import java.io.FileInputStream
import java.io.InputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.thegandabherunda.openjot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

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
        abortOnError = false
    }

    defaultConfig {
        applicationId = "org.thegandabherunda.openjot"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        val keystorePropertiesFile = project.rootProject.file("key.properties")
        if (keystorePropertiesFile.exists()) {
            val props = Properties()
            keystorePropertiesFile.inputStream().use { stream: InputStream ->
                props.load(stream)
            }
            val storeFileProp = props.getProperty("storeFile")
            if (storeFileProp != null) {
                val storeFileObj = file(storeFileProp)
                if (storeFileObj.exists()) {
                    create("release") {
                        storeFile = storeFileObj
                        storePassword = props.getProperty("storePassword")
                        keyAlias = props.getProperty("keyAlias")
                        keyPassword = props.getProperty("keyPassword")
                    }
                }
            }
        }
    }

    buildTypes {
        getByName("release") {
            val releaseConfig = signingConfigs.findByName("release")
            if (releaseConfig != null) {
                signingConfig = releaseConfig
            }

            isMinifyEnabled = true
            isShrinkResources = true
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

    flavorDimensions.add("distribution")
    productFlavors {
        create("foss") {
            dimension = "distribution"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
