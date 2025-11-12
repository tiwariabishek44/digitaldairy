import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Firebase plugin
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.sphirontech.digitaldairy"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // ✅ Enable desugaring for modern Java APIs
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.sphirontech.digitaldairy"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

   // signingConfigs {
        // ✅ Optional: release signing (works only if you have key.properties)
   //     create("release") {
   //         keyAlias = keystoreProperties["keyAlias"] as String?
   //         keyPassword = keystoreProperties["keyPassword"] as String?
   //         storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
   //         storePassword = keystoreProperties["storePassword"] as String?
   //     }
   // }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.findByName("release")
            // You can also enable minify/proguard if you want:
            // isMinifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Core library desugaring dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // ✅ Firebase BoM (manages all Firebase versions automatically)
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

   
}
