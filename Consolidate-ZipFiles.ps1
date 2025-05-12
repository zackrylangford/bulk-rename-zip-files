<#
.SYNOPSIS
    Consolidates zip files from multiple directories into a single directory, automatically handling naming conflicts.

.DESCRIPTION
    This script finds all zip files in the specified source directories and copies them to a single destination directory.
    When filename conflicts are detected, it automatically renames the files using a unique identifier (folder name + sequential number).
    This solves the problem of having multiple files with the same name in different directories that need to be consolidated.

.PARAMETER SourceDirectories
    An array of directories to search for zip files. Can use wildcards to specify multiple directories.

.PARAMETER DestinationDirectory
    The directory where all zip files will be copied to.

.PARAMETER Method
    The method to use for renaming when conflicts are detected:
    - FolderName: Uses the parent folder name as part of the new filename (default)
    - Sequential: Adds a sequential number to conflicting filenames
    - Timestamp: Adds a timestamp to conflicting filenames

.PARAMETER DryRun
    If specified, shows what would be done without actually copying or renaming files.

.EXAMPLE
    # Consolidate zip files from multiple specific directories
    .\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Folder1", "C:\Folder2" -DestinationDirectory "C:\AllZips"

.EXAMPLE
    # Consolidate zip files from all subdirectories of a parent directory
    .\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips"

.EXAMPLE
    # Preview what would happen without making changes
    .\Consolidate-ZipFiles.ps1 -SourceDirectories "C:\Parent\*" -DestinationDirectory "C:\AllZips" -DryRun
#>

param (
    [Parameter(Mandatory = $true)]
    [string[]]$SourceDirectories,
    
    [Parameter(Mandatory = $true)]
    [string]$DestinationDirectory,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("FolderName", "Sequential", "Timestamp")]
    [string]$Method = "FolderName",
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun
)

# Function to ensure destination directory exists
function Ensure-DirectoryExists {
    param (
        [string]$Directory
    )
    
    if (-not (Test-Path -Path $Directory -PathType Container)) {
        if (-not $DryRun) {
            try {
                New-Item -Path $Directory -ItemType Directory -Force | Out-Null
                Write-Host "Created destination directory: $Directory"
            }
            catch {
                Write-Error "Failed to create directory '$Directory': $_"
                exit 1
            }
        }
        else {
            Write-Host "Would create directory: $Directory"
        }
    }
}

# Function to get a unique filename when conflicts are detected
function Get-UniqueFileName {
    param (
        [string]$OriginalPath,
        [string]$DestinationPath,
        [string]$Method,
        [int]$Counter = 1
    )
    
    $fileName = [System.IO.Path]::GetFileName($OriginalPath)
    $fileNameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $extension = [System.IO.Path]::GetExtension($fileName)
    $parentFolder = Split-Path -Path (Split-Path -Path $OriginalPath -Parent) -Leaf
    
    switch ($Method) {
        "FolderName" {
            # Use parent folder name to make filename unique
            $newFileName = "${fileNameWithoutExt}_from_${parentFolder}${extension}"
            $newPath = Join-Path -Path $DestinationDirectory -ChildPath $newFileName
            
            # If still a conflict, add a number
            if (Test-Path -Path $newPath) {
                $newFileName = "${fileNameWithoutExt}_from_${parentFolder}_${Counter}${extension}"
                $newPath = Join-Path -Path $DestinationDirectory -ChildPath $newFileName
                if (Test-Path -Path $newPath) {
                    return Get-UniqueFileName -OriginalPath $OriginalPath -DestinationPath $DestinationPath -Method $Method -Counter ($Counter + 1)
                }
            }
        }
        "Sequential" {
            $newFileName = "${fileNameWithoutExt}_${Counter}${extension}"
            $newPath = Join-Path -Path $DestinationDirectory -ChildPath $newFileName
            if (Test-Path -Path $newPath) {
                return Get-UniqueFileName -OriginalPath $OriginalPath -DestinationPath $DestinationPath -Method $Method -Counter ($Counter + 1)
            }
        }
        "Timestamp" {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss_fff"
            $newFileName = "${fileNameWithoutExt}_${timestamp}${extension}"
            $newPath = Join-Path -Path $DestinationDirectory -ChildPath $newFileName
        }
    }
    
    return $newPath
}

# Main script execution
Write-Host "Starting zip file consolidation process..."

# Ensure destination directory exists
Ensure-DirectoryExists -Directory $DestinationDirectory

# Find all zip files in source directories
$allZipFiles = @()
foreach ($sourceDir in $SourceDirectories) {
    # Handle wildcards in source directories
    $matchingDirs = @(Get-Item -Path $sourceDir -ErrorAction SilentlyContinue)
    
    if ($matchingDirs.Count -eq 0) {
        Write-Warning "No directories found matching pattern: $sourceDir"
        continue
    }
    
    foreach ($dir in $matchingDirs) {
        if ($dir.PSIsContainer) {
            $zipFiles = Get-ChildItem -Path $dir.FullName -Filter "*.zip" -File -Recurse
            $allZipFiles += $zipFiles
            Write-Host "Found $($zipFiles.Count) zip files in $($dir.FullName)"
        }
    }
}

if ($allZipFiles.Count -eq 0) {
    Write-Host "No zip files found in the specified source directories."
    exit 0
}

Write-Host "Found a total of $($allZipFiles.Count) zip files across all source directories."

# Track statistics
$copiedCount = 0
$renamedCount = 0
$errorCount = 0

# Process each zip file
foreach ($zipFile in $allZipFiles) {
    $destinationPath = Join-Path -Path $DestinationDirectory -ChildPath $zipFile.Name
    
    # Check if a file with the same name already exists in the destination
    if (Test-Path -Path $destinationPath) {
        # Need to rename to avoid conflict
        $newPath = Get-UniqueFileName -OriginalPath $zipFile.FullName -DestinationPath $destinationPath -Method $Method
        $newFileName = Split-Path -Path $newPath -Leaf
        
        if ($DryRun) {
            Write-Host "Would copy and rename: $($zipFile.FullName) -> $newPath (conflict detected)"
        }
        else {
            try {
                Copy-Item -Path $zipFile.FullName -Destination $newPath -Force
                Write-Host "Copied and renamed: $($zipFile.Name) -> $newFileName (conflict resolved)"
                $renamedCount++
            }
            catch {
                Write-Error "Failed to copy file '$($zipFile.FullName)': $_"
                $errorCount++
            }
        }
    }
    else {
        # No conflict, copy directly
        if ($DryRun) {
            Write-Host "Would copy: $($zipFile.FullName) -> $destinationPath"
        }
        else {
            try {
                Copy-Item -Path $zipFile.FullName -Destination $destinationPath -Force
                Write-Host "Copied: $($zipFile.Name)"
                $copiedCount++
            }
            catch {
                Write-Error "Failed to copy file '$($zipFile.FullName)': $_"
                $errorCount++
            }
        }
    }
}

# Display summary
if ($DryRun) {
    Write-Host "`nDry run completed. Would process $($allZipFiles.Count) files."
}
else {
    Write-Host "`nConsolidation completed:"
    Write-Host "- Files copied without renaming: $copiedCount"
    Write-Host "- Files renamed due to conflicts: $renamedCount"
    Write-Host "- Errors encountered: $errorCount"
    Write-Host "- Total files processed: $($copiedCount + $renamedCount)"
    Write-Host "- Destination directory: $DestinationDirectory"
}