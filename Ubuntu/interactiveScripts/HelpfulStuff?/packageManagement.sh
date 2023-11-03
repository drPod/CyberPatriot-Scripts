#!/bin/bash

# Function to update package repository information
update_packages() {
  echo "Updating package repository information..."
  sudo apt-get update
  echo "Package repository information updated successfully."
}

# Function to install packages
install_packages() {
  echo "Installing packages..."
  sudo apt-get install "$@"
  echo "Packages installed successfully."
}

# Function to remove packages
remove_packages() {
  echo "Removing packages..."
  sudo apt-get remove "$@"
  echo "Packages removed successfully."
}

# Function to upgrade all installed packages
upgrade_packages() {
  echo "Upgrading all installed packages..."
  sudo apt-get upgrade
  echo "All installed packages upgraded successfully."
}

# Function to search for packages based on a keyword
search_packages() {
  echo "Searching for packages based on keyword: $1"
  apt-cache search "$1"
}

# Main function to handle user input and call appropriate functions
main() {
  echo "Welcome to the package management script!"
  echo "Please select an option:"
  echo "1. Update package repository information"
  echo "2. Install package(s)"
  echo "3. Remove package(s)"
  echo "4. Upgrade all installed packages"
  echo "5. Search for packages based on a keyword"
  read -r choice

  case $choice in
  1)
    update_packages
    ;;
  2)
    echo "Please enter the name(s) of the package(s) you want to install:"
    read -r packages
    install_packages "$packages"
    ;;
  3)
    echo "Please enter the name(s) of the package(s) you want to remove:"
    read -r packages
    remove_packages "$packages"
    ;;
  4)
    upgrade_packages
    ;;
  5)
    echo "Please enter a keyword to search for packages:"
    read -r keyword
    search_packages "$keyword"
    ;;
  *)
    echo "Invalid choice. Please try again."
    ;;
  esac
}

# Call the main function
main
