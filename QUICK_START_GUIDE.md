# Quick Start Guide for Tom

This guide will help you quickly consolidate your zip files that have the same name into a single folder.

## What This Will Do

This tool will:
1. Find all your zip files across multiple folders
2. Copy them to a single folder you choose
3. Automatically rename any files with the same name
4. Keep your original files untouched and safe

## Step-by-Step Instructions

### Step 1: Download the Tool

1. Go to this web address in your browser:
   ```
   https://github.com/zackrylangford/bulk-rename-zip-files/archive/refs/heads/main.zip
   ```

2. Save the file to your Downloads folder

3. Find the downloaded zip file and extract it:
   - Right-click on the zip file
   - Select "Extract All..."
   - Choose a location (like your Desktop)
   - Click "Extract"

### Step 2: Open PowerShell

1. Open the extracted folder (called "bulk-rename-zip-files-main")

2. Hold down the Shift key and right-click in an empty area of the folder

3. Select "Open PowerShell window here"

### Step 3: Run the Tool

In the PowerShell window that opens, type this command (replacing the paths with your actual folders):

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Path\To\Your\Folders\*" -DestinationDirectory "C:\Path\Where\You\Want\Files"
```

#### Example:

If your numbered folders (1-50) are on your Desktop, and you want to put all the zip files into a new folder called "AllZips" on your Desktop:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\YourUsername\Desktop\*" -DestinationDirectory "C:\Users\YourUsername\Desktop\AllZips"
```

(Replace "YourUsername" with your actual Windows username)

### Step 4: Check the Results

1. The tool will show you what it's doing as it works
2. When it's done, open the destination folder to see all your consolidated files
3. Your original files will still be in their original locations, untouched

## Need Help?

If you run into any issues:

1. Try the "Preview Mode" to see what would happen without making changes:
   ```
   .\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\YourUsername\Desktop\*" -DestinationDirectory "C:\Users\YourUsername\Desktop\AllZips" -DryRun
   ```

2. If you get an error about "execution policy", run this command and then try again:
   ```
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   ```

3. For more detailed instructions, open the "DOWNLOAD_AND_RUN_INSTRUCTIONS.md" file in the folder.