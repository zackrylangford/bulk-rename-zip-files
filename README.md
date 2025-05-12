# Bulk Rename and Consolidate Zip Files

This project provides PowerShell scripts to solve common problems with zip files that have the same name across multiple folders.

## The Problem

When you have multiple zip files with identical names in different folders and try to copy them all to a single location, Windows warns about name conflicts and asks if you want to replace or skip files.

## The Solution

This project offers two different scripts:

### 1. Consolidate-ZipFiles.ps1 (Recommended)

**Best for:** Gathering files from multiple folders into one location while preserving all files.

This script:
- Finds all zip files across multiple folders
- Copies them to a single destination folder
- Automatically renames files when conflicts are detected
- Preserves the original filename while adding information about where the file came from

[See detailed instructions](CONSOLIDATION_INSTRUCTIONS.md)

### 2. Rename-ZipFiles.ps1

**Best for:** Renaming zip files within a single folder to make them unique.

This script:
- Renames all zip files in a specified directory
- Adds a unique identifier to each filename (sequential number, timestamp, or UUID)
- Useful when you've already copied files to a single location and need to resolve conflicts

[See detailed instructions](WINDOWS_INSTRUCTIONS.md)

## Quick Start

### Consolidating Files from Multiple Folders

```powershell
# Basic usage
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Folder1", "C:\Folder2" -DestinationDirectory "C:\AllZips"

# Using wildcards to specify multiple folders
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips"

# Preview what would happen without making changes
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips" -DryRun
```

### Renaming Files in a Single Folder

```powershell
# Basic usage
.\Rename-ZipFiles.ps1 -Directory "C:\path\to\zip\files"

# Preview changes without actually renaming files
.\Rename-ZipFiles.ps1 -Directory "C:\path\to\zip\files" -DryRun
```

## Python Alternative

For users on macOS or Linux, a Python script (`rename_zip_files.py`) is also available that provides similar functionality to the PowerShell scripts.