# GitHub Actions Workflows

This repository contains several GitHub Actions workflows for automated building and maintenance.

## Current Workflows

### 1. `dozzle.yml` - Manual Version Management (Currently Active)
- **Permissions**: Read-only, no commit permissions needed
- **Version Management**: Manual (you update versions in config/build files)
- **Suitable for**: Users who prefer manual version control

**How it works:**
1. Detects when Dozzle has a new release
2. Builds containers using your manually set versions
3. Publishes to GitHub Packages
4. Does NOT commit version changes back to repo

### 2. `dozzle-auto-commit.yml` - Automatic Version Management (Alternative)
- **Permissions**: Requires write permissions to repository
- **Version Management**: Automatic (workflow updates version files)
- **Suitable for**: Fully automated workflow

**To enable this workflow:**
1. Rename `dozzle-auto-commit.yml` to `dozzle.yml` (replacing the current one)
2. Go to Repository Settings → Actions → General → Workflow permissions
3. Select "Read and write permissions"
4. Check "Allow GitHub Actions to create and approve pull requests"

### 3. `cleanup-packages.yml` - Package Maintenance
- **Schedule**: Weekly (Sundays at 3 AM UTC)
- **Purpose**: Cleans up old container versions to save storage
- **Permissions**: Packages write only

## Permission Issues

If you see errors like:
```
Permission to kernelkaribou/homeassistant.git denied to github-actions[bot]
```

This means GitHub Actions doesn't have permission to push commits. You have two options:

### Option 1: Keep Manual Version Management (Recommended)
- Use the current `dozzle.yml` workflow
- Manually update version numbers in `config.yaml` and `build.yaml`
- Workflow builds and publishes containers
- No permission changes needed

### Option 2: Enable Automatic Version Management
- Use the `dozzle-auto-commit.yml` workflow instead
- Grant write permissions in repository settings
- Workflow automatically updates version files and commits changes

## Building Process

The workflow will:
1. ✅ Check for new Dozzle releases
2. ✅ Build multi-architecture containers (amd64, aarch64, armv7)
3. ✅ Publish to `ghcr.io/kernelkaribou/homeassistant/addon-dozzle`
4. ✅ Log build completion

## Manual Triggering

You can manually trigger builds by:
1. Going to Actions tab in GitHub
2. Selecting "Build and Publish Dozzle Addon"
3. Clicking "Run workflow"

This is useful for testing or rebuilding after script fixes.