#!/bin/bash

# Function to list running processes and display their resource utilization
function list_processes() {
    echo "Listing running processes and their resource utilization..."
    ps aux | awk '{print $2, $3, $4, $11}' | head -n 1 && ps aux | awk '{if($11 != "awk") print $2, $3, $4, $11}' | sort -k3 -r | head -n 10
}

# Function to terminate specific processes based on their names or PIDs
function terminate_process() {
    echo "Enter the name or PID of the process you want to terminate:"
    read process_info
    if [[ $process_info =~ ^[0-9]+$ ]]; then
        kill $process_info
    else
        pkill $process_info
    fi
    echo "Process terminated successfully."
}

# Function to monitor and limit resource usage of specific processes
function monitor_process() {
    echo "Enter the name or PID of the process you want to monitor:"
    read process_info
    echo "Enter the maximum CPU usage percentage (0-100):"
    read cpu_limit
    echo "Enter the maximum memory usage percentage (0-100):"
    read mem_limit
    while true; do
        cpu_usage=$(ps aux | awk -v pid=$process_info '$2 == pid {print $3}')
        mem_usage=$(ps aux | awk -v pid=$process_info '$2 == pid {print $4}')
        if (($(echo "$cpu_usage > $cpu_limit" | bc -l))); then
            echo "Process CPU usage is above the limit. Killing process..."
            kill $process_info
            break
        fi
        if (($(echo "$mem_usage > $mem_limit" | bc -l))); then
            echo "Process memory usage is above the limit. Killing process..."
            kill $process_info
            break
        fi
        sleep 1
    done
}

# Function to display system resource utilization, including CPU and memory usage
function system_resources() {
    echo "Displaying system resource utilization..."
    top -bn1 | grep "Cpu(s)" && echo "" && free -h
}

# Function to generate a report of resource-intensive processes and their impact on system performance
function resource_report() {
    echo "Generating report of resource-intensive processes and their impact on system performance..."
    ps aux | awk '{if($11 != "awk") print $2, $3, $4, $11}' | sort -k3 -r | head -n 10 >process_report.txt
    echo "Report generated successfully. Please see process_report.txt for details."
}

# Main menu
while true; do
    echo ""
    echo "Please select an option:"
    echo "1. List running processes and display their resource utilization"
    echo "2. Terminate specific processes based on their names or PIDs"
    echo "3. Monitor and limit resource usage of specific processes"
    echo "4. Display system resource utilization, including CPU and memory usage"
    echo "5. Generate a report of resource-intensive processes and their impact on system performance"
    echo "6. Exit"
    read choice
    case $choice in
    1) list_processes ;;
    2) terminate_process ;;
    3) monitor_process ;;
    4) system_resources ;;
    5) resource_report ;;
    6) exit ;;
    *) echo "Invalid option. Please try again." ;;
    esac
done
