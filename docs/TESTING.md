# Next-gen Launcher Testing Guide

This document outlines the testing strategy and procedures for the Next-gen Launcher project.

## Overview

The Next-gen Launcher project includes multiple testing approaches:
- **Unit Tests**: Automated tests for individual components
- **Instrumentation Tests**: Android UI and integration tests
- **Manual Smoke Tests**: Essential functionality verification
- **CI/CD Pipeline Tests**: Automated build and deployment validation

## Current Build Status

✅ **Latest APK Generated**: `NextGen.15.Dev.(9824e8c).github.debug.apk` (40MB)  
✅ **Unit Tests**: Passing (282 tasks completed)  
✅ **Build System**: Functional with cache workarounds  
✅ **Next-gen Branding**: Implemented and verified  

## Unit Tests

### Running Unit Tests

```bash
# Run all unit tests
./gradlew testDebugUnitTest

# Run specific variant tests
./gradlew testLawnWithQuickstepGithubDebugUnitTest

# Run with detailed output
./gradlew testDebugUnitTest --stacktrace --info
```

### Current Status
- **Result**: ✅ BUILD SUCCESSFUL
- **Tasks**: 282 actionable tasks (26 executed, 22 from cache, 234 up-to-date)
- **Duration**: ~51 seconds
- **Coverage**: Unit tests for launcher components, utilities, and business logic

## Instrumentation Tests

### Available Test Variants

The project includes instrumentation tests for multiple build variants:

```bash
# Connected device tests
./gradlew connectedDebugAndroidTest
./gradlew connectedLawnWithQuickstepGithubDebugAndroidTest

# Managed device tests (requires configured test devices)
./gradlew pixel6Api33Check
./gradlew allDevicesCheck
```

### Test Categories Available
- `connectedAndroidTest` - All connected device tests
- `connectedCheck` - All device checks on connected devices
- `deviceAndroidTest` - Tests using Device Providers
- `deviceCheck` - All device checks using test servers

### Requirements for Instrumentation Tests
- **Android Device/Emulator** connected via ADB
- **API Level**: 26-35 (as per project configuration)
- **Recommended**: Android 14 (API 34) for full feature testing

## Manual Smoke Test

### Prerequisites

1. **Device Setup**:
   - Android device/emulator running Android 14 (API 34)
   - Developer options enabled
   - USB debugging enabled
   - ADB connection verified

2. **APK Installation**:
   ```bash
   # Install debug APK
   adb install build/outputs/apk/lawnWithQuickstepGithub/debug/NextGen.15.Dev.*.github.debug.apk
   
   # Or use gradle task
   ./gradlew installLawnWithQuickstepGithubDebug
   ```

### Core Functionality Tests

#### 1. Home Launch & Basic UI
- [ ] **Launch App**: Tap Next-gen launcher icon
- [ ] **Set as Default**: Accept prompt to set as default launcher
- [ ] **Home Screen Load**: Verify home screen displays correctly
- [ ] **Wallpaper Display**: Confirm wallpaper shows properly
- [ ] **Icon Layout**: Check app icons are displayed and positioned correctly

#### 2. App Drawer Functionality
- [ ] **Swipe Up Gesture**: Swipe up from bottom to open app drawer
- [ ] **App List**: Verify all installed apps are visible
- [ ] **Scrolling**: Test vertical scrolling through app list
- [ ] **App Launch**: Tap app to launch and verify it opens
- [ ] **Back Navigation**: Return to home screen

#### 3. Quickstep Gestures (Android 10+)
- [ ] **Recent Apps**: Swipe up and hold to see recent apps
- [ ] **App Switching**: Swipe horizontally between recent apps  
- [ ] **App Dismissal**: Swipe up on recent app to close
- [ ] **Clear All**: Tap "Clear All" button (if available)

#### 4. Search Functionality  
- [ ] **Search Bar**: Tap search bar if visible
- [ ] **App Search**: Type app name and verify results
- [ ] **Web Search**: Test web search integration
- [ ] **Search Suggestions**: Verify suggestions appear

#### 5. Next-gen Branding Verification
- [ ] **App Name**: Confirm "Next-gen" appears in launcher
- [ ] **Settings Title**: Open settings → verify "Next-gen" branding
- [ ] **About Section**: Check About page shows Next-gen info
- [ ] **Package ID**: Verify package is `com.diganta.nextgen.debug`

#### 6. Accessibility Service
- [ ] **Settings Access**: Go to Android Settings → Accessibility
- [ ] **Next-gen Service**: Find "Next-gen" accessibility service
- [ ] **Enable Service**: Toggle on and test gesture features
- [ ] **Service Function**: Verify accessibility features work

#### 7. Customization Options
- [ ] **Long Press Home**: Long press empty area → Settings
- [ ] **Icon Packs**: Test icon pack selection (if available)
- [ ] **Grid Size**: Modify home screen grid layout
- [ ] **Wallpaper**: Change wallpaper through launcher
- [ ] **Themes**: Test theme switching functionality

#### 8. Performance & Stability
- [ ] **Smooth Animations**: Verify transitions are fluid
- [ ] **Memory Usage**: Check launcher doesn't consume excessive RAM
- [ ] **Battery Impact**: Monitor battery drain during testing
- [ ] **Crash Recovery**: Test launcher recovers from crashes
- [ ] **Background Behavior**: Verify launcher handles background/foreground correctly

### Advanced Feature Tests

#### Gesture Customization
- [ ] **Double Tap**: Test double tap gestures
- [ ] **Swipe Gestures**: Test left/right swipe actions
- [ ] **Custom Actions**: Verify gesture customization works

#### Smart Features
- [ ] **Smartspace**: Check "At a Glance" widget functionality
- [ ] **Suggestions**: Test app suggestions if enabled
- [ ] **Adaptive Features**: Verify launcher adapts to usage patterns

#### Multi-Display Support (if available)
- [ ] **Secondary Display**: Test on devices with multiple displays
- [ ] **Display Switching**: Verify launcher works across displays

## Automated Testing in CI

### GitHub Actions Integration

Our CI pipeline includes:

```yaml
# Unit tests run on every PR/push
- name: Run unit tests
  run: ./gradlew testDebugUnitTest

# Build verification
- name: Build debug APK  
  run: ./gradlew assembleLawnWithQuickstepGithubDebug

# Cache maintenance (daily)
- name: Cache health check
  run: ./scripts/repair-gradle-cache.sh --skip-test
```

### Test Results Location

- **Unit Test Reports**: `build/reports/tests/testDebugUnitTest/index.html`
- **Lint Reports**: `build/reports/lint-results-debug.html`
- **APK Outputs**: `build/outputs/apk/lawnWithQuickstepGithub/debug/`

## Known Issues & Workarounds

### Cache Corruption ("Immutable Workspace" Errors)

**Problem**: Build fails with "immutable workspace" errors
```
The contents of the immutable workspace have been modified
```

**Solutions**:
1. Use alternative cache location:
   ```bash
   # Windows
   .\build_with_alt_cache.bat
   
   # Linux/macOS  
   ./scripts/repair-gradle-cache.sh
   ```

2. Manual cache cleanup:
   ```bash
   ./gradlew --stop
   rm -rf ~/.gradle/caches
   ./gradlew clean
   ```

3. Check for antivirus interference in `~/.gradle/caches`

### Resource Warnings

**Problem**: Build warnings about missing string resources
```
warn: removing resource com.diganta.nextgen.debug:string/xyz without required default value
```

**Status**: These are warnings, not errors. Build completes successfully.  
**Action**: Non-blocking; can be addressed in future releases.

## Test Environment Setup

### Recommended Testing Device Configuration

```yaml
Device Requirements:
  - Android Version: 14 (API 34)
  - Architecture: arm64-v8a or x86_64
  - RAM: 4GB+ recommended
  - Storage: 500MB+ free space
  - Features: Gesture navigation enabled

Emulator Configuration:
  - AVD: Pixel 6 API 34
  - System Image: Google APIs
  - RAM: 4096 MB
  - VM Heap: 512 MB
  - Graphics: Hardware (GLES 2.0)
```

### ADB Commands for Testing

```bash
# Verify device connection
adb devices

# Install debug APK
adb install -r build/outputs/apk/lawnWithQuickstepGithub/debug/NextGen.*.apk

# Launch launcher
adb shell am start -n com.diganta.nextgen.debug/com.diganta.nextgen.NextGenLauncher

# Check logs
adb logcat -s NextGen

# Uninstall for clean testing
adb uninstall com.diganta.nextgen.debug
```

## Test Checklist Template

Copy this checklist for each testing session:

```
Next-gen Launcher Test Session - [Date]

Environment:
- [ ] Device: ___________________
- [ ] Android Version: ___________
- [ ] APK Version: ______________
- [ ] Clean Install: Yes/No

Core Tests:
- [ ] App launch
- [ ] Home screen display  
- [ ] App drawer (swipe up)
- [ ] Recent apps gesture
- [ ] App launching
- [ ] Settings access
- [ ] Next-gen branding visible

Issues Found:
- 

Performance Notes:
- 

Overall Rating: ___/10
Recommended Actions:
- 
```

## Reporting Issues

### Bug Report Template

When reporting issues, include:

1. **Device Information**
   - Device model
   - Android version
   - APK version tested

2. **Steps to Reproduce**
   - Detailed step-by-step instructions
   - Expected behavior
   - Actual behavior

3. **Logs and Screenshots**
   - ADB logcat output
   - Screenshots/screen recordings
   - Stack traces if available

4. **Environment Details**
   - Installation method
   - Previous launcher used
   - Other launcher apps installed

---

**Next-gen Launcher Team**  
*Testing made simple and thorough*
