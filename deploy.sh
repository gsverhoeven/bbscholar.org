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

# --- EXECUTION ---
# Ensure the zip command utility is installed
if ! command -v zip &> /dev/null; then
    echo "Error: 'zip' utility is not installed. Please install it first (e.g., sudo apt install zip)."
    exit 1
fi

echo "Compressing '$SOURCE_FOLDER' into '$LOCAL_FILE'..."

# Perform recursive compression (-r) in quiet mode (-q)
zip -r "$LOCAL_FILE" "$SOURCE_FOLDER"


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


