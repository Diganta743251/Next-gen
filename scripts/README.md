# Next-gen Launcher - Cache Management

This directory contains scripts and tools for managing Gradle caches in the Next-gen Launcher project.

## Background

During development, we encountered "immutable workspace" errors and cache corruption issues that prevented successful builds. These scripts provide robust solutions for cache maintenance.

## Scripts

### `repair-gradle-cache.sh` (Linux/macOS)

Comprehensive cache repair script for Unix-like systems.

**Usage:**
```bash
# Basic cache repair
./scripts/repair-gradle-cache.sh

# Force clean all caches (more aggressive)
./scripts/repair-gradle-cache.sh --force

# Skip build test after repair
./scripts/repair-gradle-cache.sh --skip-test

# Show help
./scripts/repair-gradle-cache.sh --help
```

### `repair-gradle-cache.ps1` (Windows)

PowerShell version for Windows systems.

**Usage:**
```powershell
# Basic cache repair
.\scripts\repair-gradle-cache.ps1

# Force clean all caches
.\scripts\repair-gradle-cache.ps1 -Force

# Skip build test after repair
.\scripts\repair-gradle-cache.ps1 -SkipTest

# Show help
.\scripts\repair-gradle-cache.ps1 -Help
```

## CI Integration

### Automated Cache Maintenance

The `.github/workflows/cache-maintenance.yml` workflow provides:

- **Daily maintenance**: Runs at 2 AM UTC to prevent cache accumulation
- **Manual trigger**: Can be triggered manually with force clean option
- **Health validation**: Tests cache integrity and build success
- **Diagnostic logging**: Captures logs when issues are detected

**Manual trigger:**
1. Go to Actions tab in GitHub
2. Select "Cache Maintenance" workflow
3. Click "Run workflow"
4. Optionally enable "Force clear all Gradle caches"

### Enhanced CI Workflow

The main CI workflow (`ci.yml`) has been updated to:
- Use configuration cache (enabled in `settings.gradle`)
- Provide better cache key management
- Include cache encryption for security

## What These Scripts Do

1. **Stop Gradle Daemons**: Ensures no processes are holding cache files
2. **Clean Project Directories**: Removes local `build/` and `.gradle/` folders
3. **Clean Global Cache** (optional): Removes `~/.gradle/caches` and related directories
4. **Refresh Submodules**: Ensures Git submodules are in clean state
5. **Update Gradle Wrapper**: Ensures latest Gradle version
6. **Test Build**: Verifies the repair was successful

## Common Cache Issues

### Immutable Workspace Errors
```
Task ':app:mergeExtDex' uses this output of task ':app:checkDuplicateClasses' 
without declaring an explicit or implicit dependency
```

**Solutions:**
- Run cache repair scripts
- Use `build_with_alt_cache.bat` for alternative cache location
- Check for antivirus interference

### Duplicate Class Errors
```
Duplicate class found in modules
```

**Solutions:**
- Review dependency conflicts in `build.gradle`
- Clean all caches with `--force` flag
- Check for duplicate JAR files

### Configuration Cache Issues
```
Configuration cache problems found
```

**Solutions:**
- Run `./gradlew --stop`
- Delete configuration cache: `~/.gradle/configuration-cache`
- Re-run build

## Alternative Cache Location

For persistent issues (especially on Windows with antivirus):

Use the existing `build_with_alt_cache.bat` which:
- Creates cache in system temp directory
- Avoids antivirus interference
- Provides isolated cache environment

```batch
& .\build_with_alt_cache.bat
```

## Best Practices

1. **Regular Maintenance**: Run cache repair weekly during active development
2. **Before Major Changes**: Clean cache before switching branches or major updates
3. **CI Health**: Monitor cache maintenance workflow for early issue detection
4. **Disk Space**: Gradle caches can grow large; regular cleanup saves space
5. **Antivirus Exclusions**: Consider excluding `.gradle` directories from real-time scanning

## Troubleshooting

### Script Won't Run (Linux/macOS)
```bash
# Make script executable
chmod +x scripts/repair-gradle-cache.sh
```

### PowerShell Execution Policy (Windows)
```powershell
# Allow script execution (run as admin)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Persistent Build Issues
1. Try force clean: `--force` or `-Force`
2. Check antivirus logs for blocked files
3. Verify disk space (Gradle needs several GB)
4. Use alternative cache location script
5. Check for file permission issues

## Performance Tips

- **Configuration Cache**: Enabled by default, speeds up builds significantly
- **Build Cache**: Shared across branches, reduces compilation time
- **Parallel Builds**: Enabled in `gradle.properties` for faster multi-module builds
- **Daemon**: Keep Gradle daemon running between builds (default behavior)

## Support

If cache issues persist after running these scripts:

1. Check the diagnostic logs from cache maintenance workflow
2. Review antivirus logs for interference
3. Verify system requirements (JDK 17, sufficient disk space)
4. Consider filing an issue with build logs attached

---

**Next-gen Launcher Team**  
*Making Android launcher development smoother*
