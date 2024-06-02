#!/bin/bash

# Define the list of commands
declare -A scripts
scripts["Update and run hehe script"]="apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe"
scripts["Download and run UDPserver script"]="wget https://raw.githubusercontent.com/AVEGAH/SocksIP-udpServer/main/UDPserver.sh; chmod +x UDPserver.sh; ./UDPserver.sh"

# Function to display the menu
show_menu() {
    echo "Choose a script to install:"
    PS3="Enter your choice: "
    select option in "${!scripts[@]}" "Quit"; do
        case $option in
            "Quit")
                echo "Exiting."
                exit 0
                ;;
            *)
                if [[ -n "${scripts[$option]}" ]]; then
                    install_script "${scripts[$option]}"
                else
                    echo "Invalid option. Try again."
                fi
                ;;
        esac
    done
}

# Function to run the selected script
install_script() {
    local command=$1
    echo "Running command: $command"
    eval "$command"
}

# Show the menu
show_menu
