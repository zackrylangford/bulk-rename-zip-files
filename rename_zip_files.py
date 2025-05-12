#!/usr/bin/env python3
"""
Bulk Rename Zip Files

This script renames all zip files in a specified directory by adding a unique identifier
to prevent naming conflicts when consolidating files.
"""

import os
import sys
import time
import argparse
from datetime import datetime
from pathlib import Path


def rename_zip_files(directory, rename_method="timestamp", prefix="", dry_run=False):
    """
    Rename all zip files in the specified directory.
    
    Args:
        directory (str): Path to the directory containing zip files
        rename_method (str): Method to use for renaming ('timestamp', 'sequential', or 'uuid')
        prefix (str): Optional prefix to add to the renamed files
        dry_run (bool): If True, only show what would be done without actually renaming
    
    Returns:
        int: Number of files renamed
    """
    directory_path = Path(directory)
    if not directory_path.exists() or not directory_path.is_dir():
        print(f"Error: Directory '{directory}' does not exist or is not a directory")
        return 0
    
    # Get all zip files in the directory
    zip_files = list(directory_path.glob("*.zip"))
    if not zip_files:
        print(f"No zip files found in '{directory}'")
        return 0
    
    print(f"Found {len(zip_files)} zip files in '{directory}'")
    
    # Counter for sequential renaming
    counter = 1
    renamed_count = 0
    
    for zip_file in zip_files:
        original_name = zip_file.name
        stem = zip_file.stem
        suffix = zip_file.suffix
        
        # Generate new name based on the selected method
        if rename_method == "timestamp":
            # Use current timestamp for uniqueness
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
            new_name = f"{prefix}{stem}_{timestamp}{suffix}"
            # Small delay to ensure unique timestamps
            time.sleep(0.01)
        elif rename_method == "sequential":
            # Use sequential numbering
            new_name = f"{prefix}{stem}_{counter:03d}{suffix}"
            counter += 1
        else:  # uuid
            # Use UUID for maximum uniqueness
            import uuid
            unique_id = str(uuid.uuid4())[:8]
            new_name = f"{prefix}{stem}_{unique_id}{suffix}"
        
        new_path = zip_file.parent / new_name
        
        # Perform the rename operation
        if dry_run:
            print(f"Would rename: {original_name} -> {new_name}")
        else:
            try:
                zip_file.rename(new_path)
                print(f"Renamed: {original_name} -> {new_name}")
                renamed_count += 1
            except Exception as e:
                print(f"Error renaming {original_name}: {e}")
    
    return renamed_count


def main():
    parser = argparse.ArgumentParser(description="Rename zip files in a directory to avoid naming conflicts.")
    parser.add_argument("directory", help="Directory containing zip files to rename")
    parser.add_argument("--method", choices=["timestamp", "sequential", "uuid"], 
                        default="sequential", help="Method to use for generating unique names")
    parser.add_argument("--prefix", default="", help="Optional prefix to add to renamed files")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done without actually renaming files")
    
    args = parser.parse_args()
    
    count = rename_zip_files(args.directory, args.method, args.prefix, args.dry_run)
    
    if not args.dry_run:
        print(f"\nSuccessfully renamed {count} zip files.")
    else:
        print(f"\nDry run completed. {count} files would be renamed.")


if __name__ == "__main__":
    main()