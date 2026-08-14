# !/usr/bin/env python3
################################################################################
#
# File: tree.py
#
# Purpose: Print directory tree structure
#
# Description:
#   A simple script to print the directory tree structure of the current working directory.
#
#   Obviously there are better tools out there. This script is meant for systems
#   that aren't able to install the packages offline.
#
################################################################################

import os

def print_tree(start_path: str, prefix: str = "") -> None:
    """Recursively print a directory tree structure."""
    # Get all entries in the directory
    entries = sorted(os.listdir(start_path))
    entries_count = len(entries)

    for index, entry in enumerate(entries):
        path = os.path.join(start_path, entry)
        connector = "└── " if index == entries_count - 1 else "├── "
        print(prefix + connector + entry)

        # If entry is a directory, recurse into it
        if os.path.isdir(path):
            extension = "    " if index == entries_count - 1 else "│   "
            print_tree(path, prefix + extension)

def main():
    # Print current working directory
    current_dir = os.getcwd()
    print(f"\n📍 Current Location: {current_dir}\n")
    print("Directory Report (similar to `tree`):")
    print(current_dir)

    # Print directory tree
    print_tree(current_dir)

if __name__ == "__main__":
    main()