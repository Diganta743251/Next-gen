@echo off
REM Build script that uses alternative cache locations to avoid antivirus interference

echo Starting Next-gen build with alternative cache location...

REM Set alternative Gradle user home to avoid antivirus scanning
set GRADLE_USER_HOME=%TEMP%\gradle_cache_nextgen

REM Create the directory if it doesn't exist
if not exist "%GRADLE_USER_HOME%" mkdir "%GRADLE_USER_HOME%"

echo Using Gradle cache: %GRADLE_USER_HOME%

REM Stop any existing daemons
call gradlew.bat --stop

REM Clean build
call gradlew.bat clean

REM Build with reduced parallelism and no daemon
call gradlew.bat assembleLawnWithQuickstepGithubDebug --no-daemon --max-workers=2 --stacktrace

echo Build completed. Check above for any errors.
pause
