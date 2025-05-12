# Instructions for Consolidating Zip Files from Multiple Folders

This guide explains how to use the `Consolidate-ZipFiles.ps1` script to gather zip files from multiple folders into a single location, automatically handling naming conflicts.

## What This Script Does

This script solves the exact problem Tom is facing:
- It finds all zip files across multiple folders
- It copies them to a single destination folder
- When it finds files with the same name, it automatically renames them to avoid conflicts
- The renaming preserves the original filename while adding information about where the file came from

## Prerequisites

- Windows 7, 8, 10, or 11 (PowerShell comes pre-installed on these systems)
- Basic familiarity with Windows File Explorer

## Step 1: Download the Script

1. Download the `Consolidate-ZipFiles.ps1` file to your computer
2. Save it to an easy-to-find location, such as your Desktop or Documents folder

## Step 2: Open PowerShell

There are several ways to open PowerShell:

### Method 1: From the Start Menu
1. Click on the Start button
2. Type "PowerShell"
3. Click on "Windows PowerShell" in the search results

### Method 2: Right-click in File Explorer
1. Navigate to the folder where you saved the script
2. Hold down the Shift key and right-click in an empty area of the folder
3. Select "Open PowerShell window here" from the context menu

## Step 3: Set Execution Policy (First-time only)

If this is your first time running a PowerShell script, you may need to adjust the execution policy:

1. In PowerShell, type the following command and press Enter:
   ```
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. Type "Y" when prompted to confirm

## Step 4: Run the Script

Now you can run the script to consolidate your zip files:

### Basic Usage
```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Folder1", "C:\Folder2" -DestinationDirectory "C:\AllZips"
```

This will:
1. Look for zip files in C:\Folder1 and C:\Folder2
2. Copy them all to C:\AllZips
3. Automatically rename any files with conflicting names

### Using Wildcards to Specify Multiple Folders
If Tom has many folders with zip files (like numbered folders 1-50), he can use wildcards:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips"
```

This will find all zip files in all subfolders of C:\Parent.

### Preview Mode (Dry Run)
To see what would happen without actually copying any files:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips" -DryRun
```

## Renaming Methods

The script offers three ways to rename files when conflicts are detected:

### 1. FolderName Method (Default)
```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips" -Method FolderName
```

This adds the parent folder name to conflicting files. For example:
- Original: file.zip (from folder "January")
- Renamed: file_from_January.zip

### 2. Sequential Method
```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips" -Method Sequential
```

This adds a number to conflicting files. For example:
- Original: file.zip
- Renamed: file_1.zip, file_2.zip, etc.

### 3. Timestamp Method
```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips" -Method Timestamp
```

This adds a timestamp to conflicting files. For example:
- Original: file.zip
- Renamed: file_20230615_123045.zip

## Real-World Example for Tom

If Tom has folders named 1-50 on his desktop, each containing a zip file with the same name:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\Tom\Desktop\*" -DestinationDirectory "C:\Users\Tom\Desktop\AllZips" -Method FolderName
```

This will:
1. Create a new folder called "AllZips" on Tom's desktop
2. Copy all zip files from all folders on his desktop into this new folder
3. Rename any conflicting files to include their original folder name (e.g., "file_from_1.zip", "file_from_2.zip", etc.)

## Troubleshooting

### Script Won't Run
If you see an error about execution policy, try running:
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```
Then run the script again.

### "File Not Found" Error
Make sure you're in the correct directory where the script is located. Use `dir` or `ls` to list files in the current directory.

### Path Issues
If your path contains spaces, make sure to enclose it in quotes:
```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\Tom\My Documents\Folder 1" -DestinationDirectory "C:\Users\Tom\Desktop\All Zips"
```