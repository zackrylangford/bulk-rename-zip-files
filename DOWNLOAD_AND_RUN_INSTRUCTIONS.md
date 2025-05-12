# How to Download and Run the Zip File Consolidation Script

This guide provides simple step-by-step instructions for downloading and running the script on a Windows computer. These instructions are designed to be easy to follow, even for users with limited technical experience.

## Step 1: Download the Script

### Method 1: Direct Download (Easiest)

1. Open a web browser and go to this address:
   ```
   https://github.com/zackrylangford/bulk-rename-zip-files/archive/refs/heads/main.zip
   ```

2. The download should start automatically. If prompted, choose "Save" or "Save As".

3. Once downloaded, find the zip file in your Downloads folder.

4. Right-click on the zip file and select "Extract All...".

5. Choose a location to extract the files (like your Desktop) and click "Extract".

### Method 2: Download from GitHub Website

1. Open a web browser and go to:
   ```
   https://github.com/zackrylangford/bulk-rename-zip-files
   ```

2. Click the green "Code" button near the top of the page.

3. Select "Download ZIP" from the dropdown menu.

4. Once downloaded, find the zip file in your Downloads folder.

5. Right-click on the zip file and select "Extract All...".

6. Choose a location to extract the files (like your Desktop) and click "Extract".

## Step 2: Open PowerShell

1. Navigate to the folder where you extracted the files.

2. Hold down the Shift key and right-click in an empty area of the folder.

3. Select "Open PowerShell window here" from the context menu.
   - If you don't see this option, select "Open command window here" instead.
   - On newer Windows versions, you might see "Open in Windows Terminal" which also works.

## Step 3: Allow PowerShell to Run Scripts (First-time only)

1. In the PowerShell window, type the following command and press Enter:
   ```
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. Type "Y" when prompted to confirm.

## Step 4: Run the Script

Now you're ready to run the script to consolidate your zip files. Use the following command, adjusting the paths as needed:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Path\To\Your\Folders\*" -DestinationDirectory "C:\Path\Where\You\Want\Files"
```

### Example for Tom's Situation:

If Tom has folders named 1-50 on his Desktop, and wants to consolidate all zip files into a new folder called "AllZips" on his Desktop:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\Tom\Desktop\*" -DestinationDirectory "C:\Users\Tom\Desktop\AllZips"
```

### Try a Dry Run First (Recommended)

To see what would happen without actually copying any files:

```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\Tom\Desktop\*" -DestinationDirectory "C:\Users\Tom\Desktop\AllZips" -DryRun
```

## Common Issues and Solutions

### "File Not Found" Error
Make sure you're in the correct directory where the script is located. The PowerShell prompt should show something like:
```
PS C:\Users\Tom\Desktop\bulk-rename-zip-files-main>
```

### Path Issues
If your path contains spaces, make sure to enclose it in quotes:
```
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\Tom\My Documents\*" -DestinationDirectory "C:\Users\Tom\Desktop\All My Zips"
```

### Script Won't Run
If you see an error about execution policy, try running:
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```
Then run the script again.

### Need More Help?
For more detailed instructions, see the CONSOLIDATION_INSTRUCTIONS.md file included with the download.