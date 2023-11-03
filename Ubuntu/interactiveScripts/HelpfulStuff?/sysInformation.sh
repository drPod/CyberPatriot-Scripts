#!/bin/bash

# This script provides functions for retrieving system information on an Ubuntu system for a CyberPatriot competition.

# Function to retrieve and display the system's hostname.
get_hostname() {
    hostname
}

# Function to retrieve and display the Linux kernel version.
get_kernel_version() {
    uname -r
}

# Function to retrieve and display basic hardware information, such as CPU and RAM details.
get_hardware_info() {
    echo "CPU: $(lscpu | grep 'Model name' | awk -F ':' '{print $2}')"
    echo "RAM: $(free -h | awk '/^Mem/ {print $2}')"
}

# Function to check and display system resource utilization, including CPU and memory usage.
get_resource_utilization() {
    echo "CPU usage: $(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')"
    echo "Memory usage: $(free -m | awk '/^Mem/ {print $3 "MB / " $2 "MB"}')"
}

# Main function to call all other functions and display the results.
main() {
    echo "System Information:"
    echo "-------------------"
    echo "Hostname: $(get_hostname)"
    echo "Kernel version: $(get_kernel_version)"
    echo "Hardware information:"
    get_hardware_info
    echo "Resource utilization:"
    get_resource_utilization
}

# Call the main function.
main
