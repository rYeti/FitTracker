plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fittnes_tracker"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.fittnes_tracker"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    // Ensure Kotlin compilation targets the same JVM version
    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            // Prevent "Removing unused resources requires unused code shrinking" error
            // by disabling resource shrinking when minification is off.
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
