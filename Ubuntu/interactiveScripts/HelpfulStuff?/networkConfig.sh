#!/bin/bash

# Function to retrieve and display the system's IP address, subnet mask, and default gateway.
function display_network_info() {
    echo "IP Address: $(hostname -I | awk '{print $1}')"
    echo "Subnet Mask: $(ifconfig | grep -w "inet" | awk '{print $4}')"
    echo "Default Gateway: $(ip route | grep default | awk '{print $3}')"
}

# Function to configure a network interface with a specified IP address and subnet mask.
function configure_interface() {
    echo "Enter the name of the interface you want to configure: "
    read interface_name
    echo "Enter the IP address you want to assign to the interface: "
    read ip_address
    echo "Enter the subnet mask you want to assign to the interface: "
    read subnet_mask
    sudo ifconfig $interface_name $ip_address netmask $subnet_mask
    echo "Interface $interface_name has been configured with IP address $ip_address and subnet mask $subnet_mask."
}

# Function to restart a network interface or the entire network service.
function restart_network() {
    echo "Enter the name of the interface you want to restart (or 'all' to restart the entire network service): "
    read interface_name
    if [ "$interface_name" == "all" ]; then
        sudo systemctl restart networking.service
        echo "Network service has been restarted."
    else
        sudo ifdown $interface_name && sudo ifup $interface_name
        echo "Interface $interface_name has been restarted."
    fi
}

# Function to list all active network interfaces and their configurations.
function list_interfaces() {
    echo "Active network interfaces:"
    ifconfig -s | awk '{print $1}' | tail -n +2 | while read interface_name; do
        echo "Interface: $interface_name"
        echo "IP Address: $(ifconfig $interface_name | grep -w "inet" | awk '{print $2}')"
        echo "Subnet Mask: $(ifconfig $interface_name | grep -w "inet" | awk '{print $4}')"
        echo "MAC Address: $(ifconfig $interface_name | grep -w "ether" | awk '{print $2}')"
        echo ""
    done
}

# Function to enable or disable a network interface.
function toggle_interface() {
    echo "Enter the name of the interface you want to enable or disable: "
    read interface_name
    echo "Enter 'enable' to enable the interface or 'disable' to disable it: "
    read toggle
    if [ "$toggle" == "enable" ]; then
        sudo ifconfig $interface_name up
        echo "Interface $interface_name has been enabled."
    elif [ "$toggle" == "disable" ]; then
        sudo ifconfig $interface_name down
        echo "Interface $interface_name has been disabled."
    else
        echo "Invalid input. Please enter 'enable' or 'disable'."
    fi
}

# Main menu function to display options and call corresponding functions.
function main_menu() {
    echo "Welcome to the network configuration script."
    echo "Please select an option:"
    echo "1. Display network information"
    echo "2. Configure a network interface"
    echo "3. Restart a network interface or the entire network service"
    echo "4. List all active network interfaces and their configurations"
    echo "5. Enable or disable a network interface"
    echo "6. Exit"
    read choice
    case $choice in
    1) display_network_info ;;
    2) configure_interface ;;
    3) restart_network ;;
    4) list_interfaces ;;
    5) toggle_interface ;;
    6) exit ;;
    *) echo "Invalid input. Please enter a number between 1 and 6." ;;
    esac
}

# Call the main menu function to start the script.
main_menu
