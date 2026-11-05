#!/bin/bash

# --- CONFIGURATION ---
# Define the path to the configuration file
CONFIG_FILE="config.json"

# 1. Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' utility is required but not installed." >&2
    echo "Install it via: sudo apt install jq (Debian/Ubuntu) or brew install jq (macOS)" >&2
    exit 1
fi

# 2. Ensure the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found." >&2
    exit 1
fi

# 3. Read single parameters
# Note: Use the '-r' flag to output "raw" strings (removes JSON quotes)
SOURCE_FOLDER=$(jq -r '.SOURCE_FOLDER' "$CONFIG_FILE")
LOCAL_FILE=$(jq -r '.LOCAL_FILE' "$CONFIG_FILE")
REMOTE_USER=$(jq -r '.REMOTE_USER' "$CONFIG_FILE")
REMOTE_HOST=$(jq -r '.REMOTE_HOST' "$CONFIG_FILE")
TARGET_DIR=$(jq -r '.TARGET_DIR' "$CONFIG_FILE")

# CLEAN:

# REMOVE ALL CSV ZIP AND RDS FILES FROM PUBLIC TREE
# --- CONFIGURATION ---
# Array of file extensions to delete (do not include the dot)
EXTENSIONS=("csv" "zip" "rds")
# ---------------------

# Safety checks
if [ ! -d "$SOURCE_FOLDER" ]; then
    echo "Error: Target directory '$SOURCE_FOLDER' does not exist." >&2
    exit 1
fi

echo "Scanning '$SOURCE_FOLDER' for file types: ${EXTENSIONS[*]}..."

# Construct the find command arguments dynamically
# This handles multiple extensions in a single file-system pass
find_args=( "$SOURCE_FOLDER" -type f \( )

for i in "${!EXTENSIONS[@]}"; do
    if [ "$i" -gt 0 ]; then
        find_args+=( -o )
    fi
    find_args+=( -name "*.${EXTENSIONS[$i]}" )
done

find_args+=( \) )

# 1. DRY RUN: First, show the user what will be deleted
echo "--------------------------------------------------"
echo "The following files will be DELETED:"
echo "--------------------------------------------------"
find "${find_args[@]}" -print

echo "--------------------------------------------------"
read -p "Are you absolutely sure you want to delete these files? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Operation aborted. No files were hurt."
    exit 0
fi

# 2. ACTUAL DELETION
# Uses -print0 and xargs -0 to safely handle filenames with spaces or strange characters
echo "Deleting files..."
find "${find_args[@]}" -print0 | xargs -0 rm -f

echo "Cleanup complete!"
# --- EXECUTION ---
# Ensure the zip command utility is installed
if ! command -v zip &> /dev/null; then
    echo "Error: 'zip' utility is not installed. Please install it first (e.g., sudo apt install zip)."
    exit 1
fi

echo "Compressing '$SOURCE_FOLDER' into '$LOCAL_FILE'..."

# Perform recursive compression (-r), use FileSync to mirror contents of public folder
zip -FS -r "$LOCAL_FILE" "$SOURCE_FOLDER"


# 1. Transfer the zip file to the remote server
echo "📦 Transferring $LOCAL_FILE to $REMOTE_HOST..."
scp "$LOCAL_FILE" "${REMOTE_USER}@${REMOTE_HOST}:${TARGET_DIR}/"

# Check if the transfer was successful
if [ $? -eq 0 ]; then
    echo "✅ Transfer complete."
else
    echo "❌ Error: SCP transfer failed."
    exit 1
fi


