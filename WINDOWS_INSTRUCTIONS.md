# Windows Instructions for Renaming Zip Files

This document provides step-by-step instructions for using the PowerShell script to rename multiple zip files with the same name.

## Prerequisites

- Windows 7, 8, 10, or 11 (PowerShell comes pre-installed on these systems)
- Basic familiarity with Windows File Explorer

## Step 1: Download the Script

1. Download the `Rename-ZipFiles.ps1` file to your computer
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

### Method 3: Run Dialog
1. Press Win+R to open the Run dialog
2. Type "powershell" and press Enter

## Step 3: Set Execution Policy (First-time only)

If this is your first time running a PowerShell script, you may need to adjust the execution policy:

1. In PowerShell, type the following command and press Enter:
   ```
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. Type "Y" when prompted to confirm

## Step 4: Navigate to the Script Location

If you didn't use Method 2 above to open PowerShell directly in the script's folder, you'll need to navigate to it:

1. Use the `cd` command to change directories. For example:
   ```
   cd C:\Users\YourUsername\Desktop
   ```
   or
   ```
   cd "C:\Users\YourUsername\Documents\Scripts"
   ```

## Step 5: Run the Script

Now you can run the script with various options:

### Basic Usage (Sequential Numbering)
```
.\Rename-ZipFiles.ps1 -Directory "C:\Path\To\Your\ZipFiles"
```

### Using Timestamp Method
```
.\Rename-ZipFiles.ps1 -Directory "C:\Path\To\Your\ZipFiles" -Method Timestamp
```

### Adding a Prefix to All Files
```
.\Rename-ZipFiles.ps1 -Directory "C:\Path\To\Your\ZipFiles" -Prefix "backup_"
```

### Preview Changes Without Actually Renaming (Dry Run)
```
.\Rename-ZipFiles.ps1 -Directory "C:\Path\To\Your\ZipFiles" -DryRun
```

## Examples

### Example 1: Basic Renaming
If Tom has zip files in a folder called "MyZipFiles" on his Desktop:

```
.\Rename-ZipFiles.ps1 -Directory "C:\Users\Tom\Desktop\MyZipFiles"
```

### Example 2: Renaming with a Prefix
To add "Archive_" to the beginning of each renamed file:

```
.\Rename-ZipFiles.ps1 -Directory "C:\Users\Tom\Desktop\MyZipFiles" -Prefix "Archive_"
```

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
.\Rename-ZipFiles.ps1 -Directory "C:\Users\Tom\My Documents\Zip Files"
```