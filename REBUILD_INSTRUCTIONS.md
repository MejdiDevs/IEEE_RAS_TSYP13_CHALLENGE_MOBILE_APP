# IMPORTANT: Full Rebuild Required

## ⚠️ You MUST do a FULL REBUILD, NOT hot restart!

The error you're seeing (`channel-error`) happens because:
- The package name changed from `com.example.flutter_application_1` to `com.ras.beefast`
- Hot restart **does NOT rebuild native Android code**
- The old app with the old package name is still installed
- Firebase native plugin can't connect because it's looking for the wrong package

## Steps to Fix:

### Option 1: Using Terminal (RECOMMENDED)

1. **Stop the app completely** (close it or press Ctrl+C in terminal)

2. **Uninstall old apps:**
   ```bash
   adb uninstall com.ras.beefast
   adb uninstall com.example.flutter_application_1
   ```

3. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Option 2: Using Your IDE

1. **Stop the debug session completely** (not just pause)

2. **Uninstall the app from device/emulator:**
   - Long press app icon → Uninstall
   - OR run: `adb uninstall com.ras.beefast`

3. **Clean build:**
   - In Android Studio: Build → Clean Project
   - In VS Code: Run `flutter clean` in terminal

4. **Run the app again** (this will do a full rebuild)

## What to Expect After Full Rebuild:

You should see in console:
```
✓ Firebase initialized successfully
  App name: [DEFAULT]
  Project ID: ros2-multi-robot
```

Then products from Firestore `/products` collection will appear!

## Why Hot Restart Doesn't Work:

- **Hot Restart**: Only reloads Dart code, keeps native code as-is
- **Full Rebuild**: Rebuilds everything including native Android code with new package name

**You MUST do a full rebuild after changing package names or native configuration!**

