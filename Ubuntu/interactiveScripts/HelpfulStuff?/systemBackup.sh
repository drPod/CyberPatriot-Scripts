#!/bin/bash

# This script provides functions for managing system backups and restoration on an Ubuntu system for a CyberPatriot competition.

# Function to create a backup of specified files or directories and save it to a specified location.
function create_backup() {
    # Check if backup directory exists, if not create it
    if [ ! -d "$2" ]; then
        mkdir -p "$2"
    fi

    # Create backup archive
    tar -czvf "$2/$1.tar.gz" "$1"

    # Check if backup archive was created successfully
    if [ $? -eq 0 ]; then
        echo "Backup created successfully at $2/$1.tar.gz"
    else
        echo "Error creating backup"
    fi
}

# Function to schedule regular backups using a specified backup interval (e.g., daily, weekly).
function schedule_backup() {
    # Check if backup directory exists, if not create it
    if [ ! -d "$2" ]; then
        mkdir -p "$2"
    fi

    # Add cron job to schedule regular backups
    echo "$3 tar -czvf $2/$1.tar.gz $1" | sudo tee -a /etc/crontab >/dev/null

    # Check if cron job was added successfully
    if [ $? -eq 0 ]; then
        echo "Backup scheduled successfully"
    else
        echo "Error scheduling backup"
    fi
}

# Function to restore the system from a backup archive.
function restore_backup() {
    # Check if backup archive exists
    if [ -f "$1" ]; then
        # Extract backup archive
        tar -xzvf "$1" -C /

        # Check if backup archive was extracted successfully
        if [ $? -eq 0 ]; then
            echo "System restored successfully from $1"
        else
            echo "Error restoring system"
        fi
    else
        echo "Backup archive not found"
    fi
}

# Function to display a list of available backup archives.
function list_backups() {
    # Check if backup directory exists
    if [ -d "$1" ]; then
        # List backup archives
        ls -l "$1"/*.tar.gz
    else
        echo "Backup directory not found"
    fi
}

# Main menu
while true; do
    echo "Select an option:"
    echo "1. Create backup"
    echo "2. Schedule backup"
    echo "3. Restore system from backup"
    echo "4. List available backups"
    echo "5. Exit"
    read -p "Enter option number: " option

    case $option in
    1)
        read -p "Enter files or directories to backup: " backup_files
        read -p "Enter backup location: " backup_location
        create_backup "$backup_files" "$backup_location"
        ;;
    2)
        read -p "Enter files or directories to backup: " backup_files
        read -p "Enter backup location: " backup_location
        read -p "Enter backup interval (e.g., daily, weekly): " backup_interval
        schedule_backup "$backup_files" "$backup_location" "$backup_interval"
        ;;
    3)
        read -p "Enter backup archive location: " backup_archive
        restore_backup "$backup_archive"
        ;;
    4)
        read -p "Enter backup location: " backup_location
        list_backups "$backup_location"
        ;;
    5)
        exit 0
        ;;
    *)
        echo "Invalid option"
        ;;
    esac
done
