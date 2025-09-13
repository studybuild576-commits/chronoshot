plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.chronoshot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.chronoshot"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode.toInt()   // ✅ Int assign
        versionName = flutter.versionName           // ✅ String assign
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // TODO: Apna release keystore config yahan add karo jab Play Store pe upload karna ho
        }
    }
}

flutter {
    source = "../.."
}
