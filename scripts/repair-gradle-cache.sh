#!/bin/bash

# Next-gen Launcher - Gradle Cache Repair Script
# This script addresses common Gradle cache corruption issues

set -e

echo "🔧 Next-gen Launcher - Gradle Cache Repair"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
if [[ ! -f "build.gradle" ]] || [[ ! -f "settings.gradle" ]]; then
    print_error "This script must be run from the Next-gen project root directory"
    exit 1
fi

print_status "Detected Next-gen Launcher project"

# Parse command line arguments
FORCE_CLEAN=false
SKIP_BUILD_TEST=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE_CLEAN=true
            shift
            ;;
        --skip-test|-s)
            SKIP_BUILD_TEST=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --force, -f        Force clean all caches (more aggressive)"
            echo "  --skip-test, -s    Skip build test after cache repair"
            echo "  --help, -h         Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Step 1: Stop all Gradle daemons
print_status "Stopping Gradle daemons..."
./gradlew --stop || true

# Step 2: Clean project build directories
print_status "Cleaning project build directories..."
if [[ -d "build" ]]; then
    rm -rf build/
    print_status "Removed project build/ directory"
fi

if [[ -d ".gradle" ]]; then
    rm -rf .gradle/
    print_status "Removed project .gradle/ directory"
fi

# Step 3: Clean global Gradle cache (conditional)
if [[ "$FORCE_CLEAN" == true ]]; then
    print_warning "Force clean requested - removing global Gradle cache..."
    if [[ -d "$HOME/.gradle/caches" ]]; then
        rm -rf "$HOME/.gradle/caches"
        print_status "Removed ~/.gradle/caches"
    fi
    
    if [[ -d "$HOME/.gradle/daemon" ]]; then
        rm -rf "$HOME/.gradle/daemon"
        print_status "Removed ~/.gradle/daemon"
    fi
    
    if [[ -d "$HOME/.gradle/wrapper" ]]; then
        rm -rf "$HOME/.gradle/wrapper"
        print_status "Removed ~/.gradle/wrapper"
    fi
else
    print_status "Keeping global Gradle cache (use --force to clean)"
fi

# Step 4: Remove potential problematic cache files
print_status "Removing potentially problematic cache files..."

# Remove configuration cache
if [[ -d "$HOME/.gradle/configuration-cache" ]]; then
    rm -rf "$HOME/.gradle/configuration-cache"
    print_status "Removed configuration cache"
fi

# Remove build cache
if [[ -d "$HOME/.gradle/build-cache" ]]; then
    rm -rf "$HOME/.gradle/build-cache"
    print_status "Removed build cache"
fi

# Step 5: Clean submodules
print_status "Cleaning Git submodules..."
if [[ -f ".gitmodules" ]]; then
    git submodule deinit -f .
    git submodule update --init --recursive
    print_status "Refreshed Git submodules"
else
    print_status "No submodules found"
fi

# Step 6: Refresh Gradle wrapper
print_status "Refreshing Gradle wrapper..."
./gradlew wrapper --gradle-version=9.0.0 --distribution-type=all

# Step 7: Test build (optional)
if [[ "$SKIP_BUILD_TEST" != true ]]; then
    print_status "Testing build after cache repair..."
    
    echo ""
    print_warning "Running test build - this may take a while..."
    
    if ./gradlew clean --stacktrace; then
        print_status "Clean task successful"
    else
        print_error "Clean task failed"
        exit 1
    fi
    
    if ./gradlew assembleLawnWithQuickstepGithubDebug --stacktrace; then
        print_status "Build test successful!"
        echo ""
        print_status "🎉 Cache repair completed successfully!"
        echo ""
        echo "APK location: build/outputs/apk/lawnWithQuickstepGithub/debug/"
        ls -la build/outputs/apk/lawnWithQuickstepGithub/debug/ || true
    else
        print_error "Build test failed after cache repair"
        echo ""
        print_warning "If the issue persists:"
        echo "  1. Try running with --force flag"
        echo "  2. Check for antivirus interference"
        echo "  3. Verify disk space and permissions"
        echo "  4. Consider using alternative cache location (see build_with_alt_cache.bat)"
        exit 1
    fi
else
    print_status "Skipping build test as requested"
    print_warning "Run './gradlew assembleLawnWithQuickstepGithubDebug' to test the build"
fi

echo ""
print_status "🚀 Next-gen Launcher cache repair completed!"
print_status "You can now continue development with a clean cache environment."
