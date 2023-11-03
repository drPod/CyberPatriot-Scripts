#!/bin/bash

# This script provides functions for managing system services on an Ubuntu system for a CyberPatriot competition.

# Function to start a specific service or a list of services
start_service() {
    if [ $# -eq 0 ]; then
        echo "Please provide the name of the service(s) to start."
    else
        for service in "$@"; do
            sudo systemctl start "$service"
            echo "Started $service"
        done
    fi
}

# Function to stop a specific service or a list of services
stop_service() {
    if [ $# -eq 0 ]; then
        echo "Please provide the name of the service(s) to stop."
    else
        for service in "$@"; do
            sudo systemctl stop "$service"
            echo "Stopped $service"
        done
    fi
}

# Function to restart a specific service or a list of services
restart_service() {
    if [ $# -eq 0 ]; then
        echo "Please provide the name of the service(s) to restart."
    else
        for service in "$@"; do
            sudo systemctl restart "$service"
            echo "Restarted $service"
        done
    fi
}

# Function to check and display the status of a specific service or all services
check_status() {
    if [ $# -eq 0 ]; then
        sudo systemctl status --all
    else
        for service in "$@"; do
            sudo systemctl status "$service"
        done
    fi
}

# Function to enable a service to start at boot time
enable_service() {
    if [ $# -eq 0 ]; then
        echo "Please provide the name of the service(s) to enable."
    else
        for service in "$@"; do
            sudo systemctl enable "$service"
            echo "Enabled $service to start at boot time"
        done
    fi
}

# Function to disable a service from starting at boot time
disable_service() {
    if [ $# -eq 0 ]; then
        echo "Please provide the name of the service(s) to disable."
    else
        for service in "$@"; do
            sudo systemctl disable "$service"
            echo "Disabled $service from starting at boot time"
        done
    fi
}

# Main menu
while true; do
    echo "Please select an option:"
    echo "1. Start service(s)"
    echo "2. Stop service(s)"
    echo "3. Restart service(s)"
    echo "4. Check service status"
    echo "5. Enable service(s) to start at boot time"
    echo "6. Disable service(s) from starting at boot time"
    echo "7. Exit"
    read -r choice

    case $choice in
    1)
        shift
        start_service "$@"
        ;;
    2)
        shift
        stop_service "$@"
        ;;
    3)
        shift
        restart_service "$@"
        ;;
    4)
        shift
        check_status "$@"
        ;;
    5)
        shift
        enable_service "$@"
        ;;
    6)
        shift
        disable_service "$@"
        ;;
    7) exit ;;
    *) echo "Invalid option" ;;
    esac
done
