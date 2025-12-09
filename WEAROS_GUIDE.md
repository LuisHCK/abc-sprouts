# How to Bundle for WearOS

Since you have the `dist/game.love` file ready, follow these steps to bundle it for WearOS using the `love-android` project.

## Prerequisites
1.  **Android Studio** installed.
2.  **Git** installed.

## Steps

### 1. Clone the Love2D Android Project
Open your terminal and clone the official repository:
```bash
git clone --recurse-submodules https://github.com/love2d/love-android
```

### 2. Add Your Game
Copy your generated `dist/game.love` file into the Android project:
```bash
cp dist/game.love love-android/app/src/main/assets/game.love
```

### 3. Configure for WearOS
Open the `love-android` project in Android Studio. You need to modify `app/src/main/AndroidManifest.xml` to tell the Play Store and the device that this is a Watch app.

**Add the `uses-feature` tag:**
Inside the `<manifest>` tag (not inside `<application>`), add:
```xml
<uses-feature android:name="android.hardware.type.watch" />
```

**Add the `standalone` meta-data:**
Inside the `<application>` tag, add:
```xml
<meta-data  
    android:name="com.google.android.wearable.standalone"  
    android:value="true" />
```

### 4. Update Build Configuration
Open `app/build.gradle` and ensure the `minSdkVersion` is compatible with WearOS (usually 25 or higher is recommended for modern support).

### 5. Build the APK
1.  In Android Studio, go to **Build > Build Bundle(s) / APK(s) > Build APK(s)**.
2.  Once built, you can locate the APK in `app/build/outputs/apk/debug/`.

### 6. Testing
*   Create a **Wear OS** emulator in Android Studio (e.g., Pixel Watch or Galaxy Watch).
*   Drag and drop the APK onto the emulator to install it.

## Design Notes for WearOS
*   **Round Screens:** Remember that corners are clipped. Keep your UI centered.
*   **Input:** Touch works like a mouse click.
