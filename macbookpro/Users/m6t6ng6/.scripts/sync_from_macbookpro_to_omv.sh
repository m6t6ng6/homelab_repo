#!/bin/bash

# === CONFIGURATION ===
LOCAL_DIR="/Users/m6t6ng6/Documents/VIDEOS QUE NO PUDE GRABAR EN EXTERNO"           # Folder on your Mac
REMOTE_USER="root"	                         # Linux server user
REMOTE_HOST="omv.matanga.it"                 # Linux server hostname or IP
REMOTE_DIR="/srv/dev-disk-by-uuid-23deda77-cb32-467d-a5ae-4c93b4fe4b56/backup/macbook_docs_backup"   # Destination on the Linux server
SSH_PORT=22                                     # Optional: change if using a non-standard SSH port
SSH_KEY="/Users/m6t6ng6/.ssh/omv"

cleanup() {
    ssh "$REMOTE_USER@$REMOTE_HOST" -p $SSH_PORT -i $SSH_KEY "chmod 777 -R $REMOTE_DIR"
    exit 1
}

# trap CTRL + C interruption from user via keyboard
trap cleanup SIGINT

# === START SYNC ===
echo "Starting sync from $LOCAL_DIR to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR..."

# Using rsync over SSH
rsync -avz -e "ssh -p $SSH_PORT -i $SSH_KEY" "$LOCAL_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# === DONE ===
if [ $? -eq 0 ]; then
    cleanup
    echo "✅ Sync completed successfully."
else
    cleanup
    echo "❌ Sync failed. Please check the connection and paths."
fi
