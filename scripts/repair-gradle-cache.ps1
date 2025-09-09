# Next-gen Launcher - Gradle Cache Repair Script (PowerShell)
# This script addresses common Gradle cache corruption issues on Windows

param(
    [switch]$Force,
    [switch]$SkipTest,
    [switch]$Help
)

if ($Help) {
    Write-Host "Next-gen Launcher - Gradle Cache Repair" -ForegroundColor Green
    Write-Host "Usage: .\scripts\repair-gradle-cache.ps1 [options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -Force       Force clean all caches (more aggressive)"
    Write-Host "  -SkipTest    Skip build test after cache repair"
    Write-Host "  -Help        Show this help message"
    exit 0
}

Write-Host "🔧 Next-gen Launcher - Gradle Cache Repair" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green

# Check if we're in the right directory
if (!(Test-Path "build.gradle") -or !(Test-Path "settings.gradle")) {
    Write-Host "❌ This script must be run from the Next-gen project root directory" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Detected Next-gen Launcher project" -ForegroundColor Green

# Step 1: Stop all Gradle daemons
Write-Host "✅ Stopping Gradle daemons..." -ForegroundColor Green
try {
    & .\gradlew --stop 2>$null
} catch {
    Write-Host "⚠️  Gradle daemon stop encountered issues (continuing...)" -ForegroundColor Yellow
}

# Step 2: Clean project build directories
Write-Host "✅ Cleaning project build directories..." -ForegroundColor Green

if (Test-Path "build") {
    Remove-Item -Recurse -Force "build"
    Write-Host "✅ Removed project build\ directory" -ForegroundColor Green
}

if (Test-Path ".gradle") {
    Remove-Item -Recurse -Force ".gradle"
    Write-Host "✅ Removed project .gradle\ directory" -ForegroundColor Green
}

# Step 3: Clean global Gradle cache (conditional)
$userProfile = $env:USERPROFILE
$gradleHome = "$userProfile\.gradle"

if ($Force) {
    Write-Host "⚠️  Force clean requested - removing global Gradle cache..." -ForegroundColor Yellow
    
    $gradleCaches = @(
        "$gradleHome\caches",
        "$gradleHome\daemon", 
        "$gradleHome\wrapper",
        "$gradleHome\configuration-cache",
        "$gradleHome\build-cache"
    )
    
    foreach ($cache in $gradleCaches) {
        if (Test-Path $cache) {
            Remove-Item -Recurse -Force $cache
            Write-Host "✅ Removed $cache" -ForegroundColor Green
        }
    }
} else {
    Write-Host "✅ Keeping global Gradle cache (use -Force to clean)" -ForegroundColor Green
}

# Step 4: Clean temporary alternative cache if exists
$tempCache = "$env:LOCALAPPDATA\Temp\gradle_cache_nextgen"
if (Test-Path $tempCache) {
    Remove-Item -Recurse -Force $tempCache
    Write-Host "✅ Removed alternative temp cache: $tempCache" -ForegroundColor Green
}

# Step 5: Clean submodules
Write-Host "✅ Cleaning Git submodules..." -ForegroundColor Green
if (Test-Path ".gitmodules") {
    try {
        git submodule deinit -f .
        git submodule update --init --recursive
        Write-Host "✅ Refreshed Git submodules" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Submodule refresh encountered issues" -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ No submodules found" -ForegroundColor Green
}

# Step 6: Refresh Gradle wrapper
Write-Host "✅ Refreshing Gradle wrapper..." -ForegroundColor Green
& .\gradlew wrapper --gradle-version=9.0.0 --distribution-type=all

# Step 7: Test build (optional)
if (!$SkipTest) {
    Write-Host "✅ Testing build after cache repair..." -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Running test build - this may take a while..." -ForegroundColor Yellow
    
    Write-Host "Running clean task..." -ForegroundColor Cyan
    $cleanResult = & .\gradlew clean --stacktrace
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Clean task successful" -ForegroundColor Green
        
        Write-Host "Running debug build..." -ForegroundColor Cyan
        $buildResult = & .\gradlew assembleLawnWithQuickstepGithubDebug --stacktrace
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Build test successful!" -ForegroundColor Green
            Write-Host ""
            Write-Host "🎉 Cache repair completed successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "APK location: build\outputs\apk\lawnWithQuickstepGithub\debug\" -ForegroundColor Cyan
            
            if (Test-Path "build\outputs\apk\lawnWithQuickstepGithub\debug") {
                Get-ChildItem "build\outputs\apk\lawnWithQuickstepGithub\debug" -Name | ForEach-Object {
                    Write-Host "  $_" -ForegroundColor White
                }
            }
        } else {
            Write-Host "❌ Build test failed after cache repair" -ForegroundColor Red
            Write-Host ""
            Write-Host "⚠️  If the issue persists:" -ForegroundColor Yellow
            Write-Host "  1. Try running with -Force flag"
            Write-Host "  2. Check for antivirus interference"
            Write-Host "  3. Verify disk space and permissions"
            Write-Host "  4. Use alternative cache location (build_with_alt_cache.bat)"
            exit 1
        }
    } else {
        Write-Host "❌ Clean task failed" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Skipping build test as requested" -ForegroundColor Green
    Write-Host "⚠️  Run '.\gradlew assembleLawnWithQuickstepGithubDebug' to test the build" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🚀 Next-gen Launcher cache repair completed!" -ForegroundColor Green
Write-Host "You can now continue development with a clean cache environment." -ForegroundColor Green
