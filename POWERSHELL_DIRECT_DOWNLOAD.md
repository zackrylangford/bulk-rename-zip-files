# Direct Download Instructions Using PowerShell

This guide shows how to download and run the script directly using PowerShell, without needing to manually download and extract files.

## Option 1: One-Line Download and Run (Simplest)

You can download and run the script with a single PowerShell command. This is the easiest method for Tom to use.

1. Open PowerShell:
   - Click the Start button
   - Type "PowerShell"
   - Click on "Windows PowerShell"

2. Copy and paste this entire command into PowerShell and press Enter:

```powershell
$script = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/zackrylangford/bulk-rename-zip-files/main/Consolidate-ZipFiles.ps1'); $scriptBlock = [Scriptblock]::Create($script); Invoke-Command -ScriptBlock $scriptBlock -ArgumentList @{SourceDirectories="C:\Users\$env:USERNAME\Desktop\*"; DestinationDirectory="C:\Users\$env:USERNAME\Desktop\AllZips"}
```

3. If you get a security warning, run this command and then try again:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

This command will:
- Download the script directly from GitHub
- Run it to consolidate all zip files from folders on the Desktop
- Place the consolidated files in a new folder called "AllZips" on the Desktop

## Option 2: Step-by-Step PowerShell Method

If Tom prefers to see what's happening step by step:

1. Open PowerShell (as described above)

2. Download the script:
```powershell
$script = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/zackrylangford/bulk-rename-zip-files/main/Consolidate-ZipFiles.ps1')
```

3. Save it to a file:
```powershell
$script | Out-File -FilePath "$env:USERPROFILE\Desktop\Consolidate-ZipFiles.ps1"
```

4. Navigate to where you saved it:
```powershell
cd "$env:USERPROFILE\Desktop"
```

5. Run the script:
```powershell
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\$env:USERNAME\Desktop\*" -DestinationDirectory "C:\Users\$env:USERNAME\Desktop\AllZips"
```

## Option 3: Download All Files from Repository

If Tom wants all the files from the repository:

1. Open PowerShell

2. Run this command to download all files:
```powershell
$tempFile = "$env:TEMP\bulk-rename-zip-files.zip"
Invoke-WebRequest -Uri "https://github.com/zackrylangford/bulk-rename-zip-files/archive/refs/heads/main.zip" -OutFile $tempFile
Expand-Archive -Path $tempFile -DestinationPath "$env:USERPROFILE\Desktop" -Force
Remove-Item $tempFile
cd "$env:USERPROFILE\Desktop\bulk-rename-zip-files-main"
```

3. Run the script:
```powershell
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\$env:USERNAME\Desktop\*" -DestinationDirectory "C:\Users\$env:USERNAME\Desktop\AllZips"
```

## Customizing the Paths

In all examples above, replace the paths as needed:

- Change `"C:\Users\$env:USERNAME\Desktop\*"` to the location of Tom's folders with zip files
- Change `"C:\Users\$env:USERNAME\Desktop\AllZips"` to where Tom wants the consolidated files

## Try a Dry Run First (Recommended)

To see what would happen without actually copying any files, add `-DryRun` to the end of the command:

```powershell
.\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Users\$env:USERNAME\Desktop\*" -DestinationDirectory "C:\Users\$env:USERNAME\Desktop\AllZips" -DryRun
```