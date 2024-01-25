#!/bin/bash

# Function to set USB_MOUNT_PATH if default value is not defined
set_mount_path() {
    if [ -d "$USB_MOUNT_PATH" ]; then
        echo "USB drive is already mounted at $USB_MOUNT_PATH"
    else
        # Navigate to /media/user and find the last mounted directory
        cd /media/$USER || exit

        # Get the last directory that was mounted
        LAST_MOUNTED_DIR=$(ls -1dt */ | head -n 1)

        if [ -z "$LAST_MOUNTED_DIR" ]; then
            # If no directory found, exit with an error
            echo "Error: No USB drive found in /media/$USER."
            exit 1
        fi

        USB_MOUNT_PATH="/media/$USER/${LAST_MOUNTED_DIR}Backup/home"

        if [ ! -d "$USB_MOUNT_PATH" ]; then
            # If no directory found, create one
            echo "Creating new directory: $USB_MOUNT_PATH"
            mkdir -p "$USB_MOUNT_PATH"
        else
            echo "Operation failed at $(date)! Exiting... " >> "$LOG_FILE"
       	    exit 1
        fi

        echo "USB drive not found at the specified path. Using fallback path: $USB_MOUNT_PATH"
    fi
}

# Default mount path
USB_MOUNT_PATH="/media/$USER/6e80e928-063f-49b7-821b-f0462abaa997/Backup/home"

# Log file path
LOG_FILE="/var/log/backup_script.log"
touch $LOG_FILE && sudo chown $USER $LOG_FILE

# Set the mount path
set_mount_path

# Run the backup only if USB drive is mounted
if [ -d "$USB_MOUNT_PATH" ]; then
    # Perform backup
    sudo rsync -a --info=progress2 --human-readable --exclude="lost+found" --exclude=".cache" --exclude=".ansible" --exclude="Downloads" --exclude="VirtualBox VMs" /home/ "$USB_MOUNT_PATH"/

    # Log status
    echo "Backup completed successfully at $(date)" >> "$LOG_FILE"
    echo "To restore the backup, use the following command:" >> "$LOG_FILE"
    echo "sudo rsync -a --info=progress2 --exclude=\"lost+found\" \"$USB_MOUNT_PATH\"/ /home/" >> "$LOG_FILE"

    # Display status
    echo "Backup completed successfully."
else
    # Log error
    echo "Error: USB drive not found. Backup not performed." >> "$LOG_FILE"

    # Display error
    echo "Error: USB drive not found. Backup not performed. Check $LOG_FILE for details."
fi
