# Next-gen Launcher

*Based on Lawnchair 15 - A customizable Android launcher*

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?logo=github)](https://github.com/Diganta743251/Next-gen/actions)
[![Latest Release](https://img.shields.io/github/v/tag/Diganta743251/Next-gen?label=latest&logo=github)](https://github.com/Diganta743251/Next-gen/releases/latest)
[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/Diganta743251/Next-gen)
[![Unit Tests](https://img.shields.io/badge/unit%20tests-282%20passing-green)](https://github.com/Diganta743251/Next-gen)
[![APK Size](https://img.shields.io/badge/APK%20size-40MB-orange)](https://github.com/Diganta743251/Next-gen/releases)

## Overview

Next-gen is a custom Android launcher forked from Lawnchair 15, enhanced with additional features and performance optimizations. Built on Launcher3 from Android 15, it provides a smooth and highly customizable home screen experience.

**This is a fork of [Lawnchair Launcher](https://github.com/LawnchairLauncher/lawnchair) with custom modifications and branding.**

## Features

-   **Material You Theming:** Adapts to your wallpaper and system theme.
-   **At a Glance Widget:** Displays information *at a glance* with support for [Smartspacer](https://github.com/KieronQuinn/Smartspacer).
-   **QuickSwitch Support:** Integrates with Android Recents on Android 10 and newer. (requires root)
-   **Global Search:** Allows quick access to apps, contacts, and web results from the home screen.
-   **Customization Options:** Provides options to tweak icons, fonts, and colors to your liking.
-   And more!

## Download

🎉 **v0.1.0-nextgen** - Stable Baseline Release is now available!

This release includes a fully functional build system, Next-gen branding, and comprehensive testing infrastructure.

- **GitHub Releases:** [Download from GitHub](https://github.com/Diganta743251/Next-gen/releases)
- **Latest APK:** `NextGen.15.Dev.github.debug.apk` (40MB)
- **Build Status:** ✅ Passing with workarounds for cache issues
- **Testing:** Unit tests (282 passing) + Manual smoke test procedures

### Release Highlights

- ✅ **Stable Build System** with cache management solutions
- ✅ **Next-gen Branding** throughout the launcher interface
- ✅ **Custom Launcher Class** (`NextGenLauncher`) extending QuickstepLauncher
- ✅ **Advanced Cache Scripts** for Windows and Linux development
- ✅ **Automated CI Pipeline** with cache maintenance workflows
- ✅ **Comprehensive Testing** documentation and smoke test procedures
- ✅ **Modern Toolchain** (Gradle 9.0.0, AGP 8.13.0, Kotlin 2.1.10)

### Quick Start

1. Download the latest APK from [Releases](https://github.com/Diganta743251/Next-gen/releases)
2. Install on Android 14+ device
3. Set as default launcher
4. Enjoy the Next-gen experience!

### Build from Source

### Build from Source

1. **Clone this repository:**
   ```bash
   git clone https://github.com/Diganta743251/Next-gen.git
   cd Next-gen
   ```

2. **Build with cache management** (recommended):
   ```bash
   # Windows
   .\build_with_alt_cache.bat
   
   # Linux/macOS
   ./scripts/repair-gradle-cache.sh
   ```

3. **Alternative build methods:**
   ```bash
   # Standard build (may require cache cleanup if issues occur)
   ./gradlew assembleLawnWithQuickstepGithubDebug
   
   # Unit tests
   ./gradlew testDebugUnitTest
   ```

4. **Install APK:**
   ```bash
   adb install build/outputs/apk/lawnWithQuickstepGithub/debug/NextGen.*.apk
   ```

#### Build Troubleshooting

If you encounter "immutable workspace" errors:
1. Run the cache repair script: `./scripts/repair-gradle-cache.sh --force`
2. Use alternative cache location: `.\build_with_alt_cache.bat`
3. Check antivirus interference with `~/.gradle/caches`

See [docs/TESTING.md](docs/TESTING.md) for comprehensive testing procedures.

## Credits

**Next-gen Launcher** is based on [Lawnchair Launcher](https://github.com/LawnchairLauncher/lawnchair), which itself is based on Android's Launcher3.

- **Original Lawnchair Team:** For creating the amazing Lawnchair launcher
- **Android Open Source Project:** For Launcher3 base
- **Community:** For testing and feedback

## Contributing

Please visit the [Lawnchair Contributing Guidelines](CONTRIBUTING.md) for information and tips on contributing to Lawnchair.

## Supporting Lawnchair

If you love what we do, consider [supporting us on Open Collective](https://opencollective.com/lawnchair)! Your contributions help keep Lawnchair independent and enable us to develop faster.

A huge thank you to our **Core Backers ($5+)**:
*(These backers directly fund our Project Velocity Fund)*

[![Core Backers](https://opencollective.com/lawnchair/tiers/backer.svg?avatarHeight=64&width=890&button=false)](https://opencollective.com/lawnchair)

[Become a supporter](https://opencollective.com/lawnchair) to help us cover our operational costs, or become a Core Backer to be featured here!

## Quick links

-   [Website](https://lawnchair.app)
-   [News on Telegram](https://t.me/lawnchairci)
-   [Discord](https://discord.com/invite/3x8qNWxgGZ)
-   [Lawnchair on X (formerly Twitter)](https://x.com/lawnchairapp)
-   [_XDA_ thread](https://xdaforums.com/t/lawnchair-customizable-pixel-launcher.3627137/)

You can view all our links in the [Lawnchair Wiki](https://github.com/LawnchairLauncher/lawnchair/wiki).

<!-- Download link -->
[Nightly link]: https://nightly.link/LawnchairLauncher/lawnchair/workflows/ci/15-dev
[Obtainium link]: https://apps.obtainium.imranr.dev/redirect?r=obtainium://app/%7B%22id%22%3A%22app.lawnchair.nightly%22%2C%22url%22%3A%22https%3A%2F%2Fgithub.com%2Flawnchairlauncher%2Flawnchair%22%2C%22author%22%3A%22Lawnchair%20Launcher%22%2C%22name%22%3A%22Lawnchair%20(Debug)%22%2C%22preferredApkIndex%22%3A0%2C%22additionalSettings%22%3A%22%7B%5C%22includePrereleases%5C%22%3Atrue%2C%5C%22fallbackToOlderReleases%5C%22%3Afalse%2C%5C%22filterReleaseTitlesByRegEx%5C%22%3A%5C%22Lawnchair%20Nightly%5C%22%2C%5C%22filterReleaseNotesByRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22verifyLatestTag%5C%22%3Afalse%2C%5C%22dontSortReleasesList%5C%22%3Afalse%2C%5C%22useLatestAssetDateAsReleaseDate%5C%22%3Afalse%2C%5C%22trackOnly%5C%22%3Afalse%2C%5C%22versionExtractionRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22matchGroupToUse%5C%22%3A%5C%22%5C%22%2C%5C%22versionDetection%5C%22%3Afalse%2C%5C%22releaseDateAsVersion%5C%22%3Atrue%2C%5C%22useVersionCodeAsOSVersion%5C%22%3Afalse%2C%5C%22apkFilterRegEx%5C%22%3A%5C%22%5C%22%2C%5C%22invertAPKFilter%5C%22%3Afalse%2C%5C%22autoApkFilterByArch%5C%22%3Atrue%2C%5C%22appName%5C%22%3A%5C%22%5C%22%2C%5C%22shizukuPretendToBeGooglePlay%5C%22%3Afalse%2C%5C%22exemptFromBackgroundUpdates%5C%22%3Afalse%2C%5C%22skipUpdateNotifications%5C%22%3Afalse%2C%5C%22about%5C%22%3A%5C%22Lawnchair%20is%20a%20free%2C%20open-source%20home%20app%20for%20Android.%20(NOTE%3A%20This%20is%20the%20debug%20version%20of%20Lawnchair%2C%20for%20the%20beta%2Fstable%20versions%20see%20%5C%5C%5C%22Lawnchair%5C%5C%5C%22)%5C%22%7D%22%7D
[GitHub link]: https://github.com/LawnchairLauncher/lawnchair/releases/tag/nightly
