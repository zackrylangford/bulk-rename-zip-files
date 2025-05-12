# Super Simple Instructions for Tom

## Just Copy and Paste This Command

1. Press the Windows key (or click Start)
2. Type "PowerShell" and click on "Windows PowerShell"
3. Copy this entire command:

```powershell
$script = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/zackrylangford/bulk-rename-zip-files/main/Consolidate-ZipFiles.ps1'); Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; $scriptBlock = [Scriptblock]::Create($script); Invoke-Command -ScriptBlock $scriptBlock -ArgumentList @{SourceDirectories="C:\Users\$env:USERNAME\Desktop\*"; DestinationDirectory="C:\Users\$env:USERNAME\Desktop\AllZips"}
```

4. Paste it into PowerShell and press Enter

That's it! This will:
- Download the script directly from the internet
- Find all zip files in folders on your Desktop
- Copy them to a new folder called "AllZips" on your Desktop
- Automatically rename any files that have the same name

## Want to See What Will Happen First?

Use this command instead to preview without making any changes:

```powershell
$script = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/zackrylangford/bulk-rename-zip-files/main/Consolidate-ZipFiles.ps1'); Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; $scriptBlock = [Scriptblock]::Create($script); Invoke-Command -ScriptBlock $scriptBlock -ArgumentList @{SourceDirectories="C:\Users\$env:USERNAME\Desktop\*"; DestinationDirectory="C:\Users\$env:USERNAME\Desktop\AllZips"; DryRun=$true}
```

## Need to Change Where to Look for Files?

If your folders with zip files are somewhere else (not on your Desktop), you'll need to change the path in the command.

For example, if your folders are in your Documents folder, change:
`C:\Users\$env:USERNAME\Desktop\*` to `C:\Users\$env:USERNAME\Documents\*`