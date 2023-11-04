#!/bin/bash

# Function to continuously monitor system resource utilization
function monitor_resources() {
    echo "Monitoring system resource utilization..."
    while true; do
        # Display real-time statistics for CPU, memory, and disk space
        echo "CPU usage: $(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')"
        echo "Memory usage: $(free | awk '/Mem/{printf "%.2f%%\n", $3/$2*100}')"
        echo "Disk space usage: $(df -h / | awk '/\//{print $(NF-1)}')"
        sleep 5
    done
}

# Function to generate reports on resource utilization and system performance over a specific time period
function generate_reports() {
    echo "Generating reports on resource utilization and system performance..."
    # Prompt user for time period to generate report for
    read -p "Enter time period (in minutes) to generate report for: " time_period
    # Generate report for CPU, memory, and disk space utilization over specified time period
    echo "CPU usage report:"
    sar -u -f /var/log/sysstat/sa$(date +%d -d "yesterday") -s $(date +%H:%M:%S -d "$time_period minutes ago") -e $(date +%H:%M:%S)
    echo "Memory usage report:"
    sar -r -f /var/log/sysstat/sa$(date +%d -d "yesterday") -s $(date +%H:%M:%S -d "$time_period minutes ago") -e $(date +%H:%M:%S)
    echo "Disk space usage report:"
    sar -b -f /var/log/sysstat/sa$(date +%d -d "yesterday") -s $(date +%H:%M:%S -d "$time_period minutes ago") -e $(date +%H:%M:%S)
}

# Function to monitor network activity and display active connections
function monitor_network() {
    echo "Monitoring network activity and displaying active connections..."
    # Display active connections
    netstat -an | grep ESTABLISHED
}

# Function to automate the generation of security reports based on system logs and scanning results
function generate_security_reports() {
    echo "Automating the generation of security reports based on system logs and scanning results..."
    # Generate report based on system logs
    echo "System logs report:"
    cat /var/log/syslog | grep -i "error\|fail\|denied"
    # Generate report based on scanning results
    echo "Scanning results report:"
    clamscan -r / | grep FOUND
}

# Function to provide a summary report of the system's overall health and security status
function summary_report() {
    echo "Generating summary report of system's overall health and security status..."
    # Display system resource utilization summary
    echo "System resource utilization summary:"
    top -bn1 | grep "Cpu\|Mem\|Tasks"
    # Display network activity summary
    echo "Network activity summary:"
    netstat -s | grep -i "active\|retransmitted\|errors\|segments"
    # Display security status summary
    echo "Security status summary:"
    echo "Firewall status: $(ufw status)"
    echo "Open ports: $(nmap localhost | grep open)"
    echo "Rootkit scan: $(rkhunter -c --sk)"
}

# Main function to prompt user for action to perform
function main() {
    echo "Welcome to the system health and security monitoring script!"
    while true; do
        echo "Please select an action to perform:"
        echo "1. Monitor system resource utilization"
        echo "2. Generate reports on resource utilization and system performance"
        echo "3. Monitor network activity and display active connections"
        echo "4. Automate the generation of security reports based on system logs and scanning results"
        echo "5. Provide a summary report of the system's overall health and security status"
        echo "6. Exit"
        read -p "Enter your choice: " choice
        case $choice in
        1) monitor_resources ;;
        2) generate_reports ;;
        3) monitor_network ;;
        4) generate_security_reports ;;
        5) summary_report ;;
        6) exit ;;
        *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

# Call main function
main
