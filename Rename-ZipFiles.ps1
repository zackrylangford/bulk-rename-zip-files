<#
.SYNOPSIS
    Renames zip files in a directory by adding unique identifiers to prevent naming conflicts.

.DESCRIPTION
    This script scans a specified directory for zip files and renames them by adding
    a unique identifier (sequential number, timestamp, or UUID) to each filename.
    This helps when consolidating files with the same name from different locations.

.PARAMETER Directory
    The directory containing the zip files to rename.

.PARAMETER Method
    The method to use for generating unique names:
    - Sequential: Adds a sequential number (e.g., file_001.zip)
    - Timestamp: Adds a timestamp (e.g., file_20230615_123045.zip)
    - UUID: Adds a random unique identifier (e.g., file_a1b2c3d4.zip)
    Default is "Sequential".

.PARAMETER Prefix
    Optional prefix to add to renamed files.

.PARAMETER DryRun
    If specified, shows what would be done without actually renaming files.

.EXAMPLE
    .\Rename-ZipFiles.ps1 -Directory "C:\MyFiles"

.EXAMPLE
    .\Rename-ZipFiles.ps1 -Directory "C:\MyFiles" -Method Timestamp

.EXAMPLE
    .\Rename-ZipFiles.ps1 -Directory "C:\MyFiles" -Prefix "backup_" -DryRun
#>

param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Directory,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("Sequential", "Timestamp", "UUID")]
    [string]$Method = "Sequential",
    
    [Parameter(Mandatory = $false)]
    [string]$Prefix = "",
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun
)

# Function to rename zip files
function Rename-ZipFiles {
    param (
        [string]$Directory,
        [string]$Method,
        [string]$Prefix,
        [switch]$DryRun
    )
    
    # Check if directory exists
    if (-not (Test-Path -Path $Directory -PathType Container)) {
        Write-Error "Error: Directory '$Directory' does not exist or is not a directory"
        return 0
    }
    
    # Get all zip files in the directory
    $zipFiles = Get-ChildItem -Path $Directory -Filter "*.zip"
    
    if ($zipFiles.Count -eq 0) {
        Write-Host "No zip files found in '$Directory'"
        return 0
    }
    
    Write-Host "Found $($zipFiles.Count) zip files in '$Directory'"
    
    # Counter for sequential renaming
    $counter = 1
    $renamedCount = 0
    
    foreach ($zipFile in $zipFiles) {
        $originalName = $zipFile.Name
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($originalName)
        $suffix = [System.IO.Path]::GetExtension($originalName)
        
        # Generate new name based on the selected method
        switch ($Method) {
            "Timestamp" {
                $timestamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
                $newName = "$Prefix$stem`_$timestamp$suffix"
                # Small delay to ensure unique timestamps
                Start-Sleep -Milliseconds 10
            }
            "UUID" {
                $uniqueId = [guid]::NewGuid().ToString().Substring(0, 8)
                $newName = "$Prefix$stem`_$uniqueId$suffix"
            }
            default {  # Sequential
                $newName = "$Prefix$stem`_$("{0:D3}" -f $counter)$suffix"
                $counter++
            }
        }
        
        $newPath = Join-Path -Path $zipFile.DirectoryName -ChildPath $newName
        
        # Perform the rename operation
        if ($DryRun) {
            Write-Host "Would rename: $originalName -> $newName"
        }
        else {
            try {
                Rename-Item -Path $zipFile.FullName -NewName $newName -ErrorAction Stop
                Write-Host "Renamed: $originalName -> $newName"
                $renamedCount++
            }
            catch {
                Write-Error "Error renaming $originalName: $_"
            }
        }
    }
    
    return $renamedCount
}

# Main script execution
$count = Rename-ZipFiles -Directory $Directory -Method $Method -Prefix $Prefix -DryRun:$DryRun

if ($DryRun) {
    Write-Host "`nDry run completed. $count files would be renamed."
}
else {
    Write-Host "`nSuccessfully renamed $count zip files."
}