#!/bin/bash

# Define the list of commands
declare -A scripts
scripts["Update and run hehe script"]="apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe"
scripts["Download and run UDPserver script"]="wget https://raw.githubusercontent.com/AVEGAH/SocksIP-udpServer/main/UDPserver.sh; chmod +x UDPserver.sh; ./UDPserver.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII Art Header
show_header() {
    echo -e "${BLUE}"
    echo "  ____             _            ____            _       _     "
    echo " |  _ \  ___  _ __| |_ ___ _ __|  _ \ ___  __ _(_) __ _| |___ "
    echo " | | | |/ _ \| '__| __/ _ \ '__| |_) / _ \/ _\` | |/ _\` | / __|"
    echo " | |_| | (_) | |  | ||  __/ |  |  __/  __/ (_| | | (_| | \__ \\"
    echo " |____/ \___/|_|   \__\___|_|  |_|   \___|\__, |_|\__,_|_|___/"
    echo "                                        |___/                "
    echo -e "${NC}"
}

# Function to display the menu
show_menu() {
    echo -e "${YELLOW}Choose a script to install:${NC}"
    PS3="Enter your choice: "
    select option in "${!scripts[@]}" "Quit"; do
        case $option in
            "Quit")
                echo -e "${RED}Exiting.${NC}"
                exit 0
                ;;
            *)
                if [[ -n "${scripts[$option]}" ]]; then
                    install_script "${scripts[$option]}"
                else
                    echo -e "${RED}Invalid option. Try again.${NC}"
                fi
                ;;
        esac
    done
}

# Function to run the selected script
install_script() {
    local command=$1
    echo -e "${GREEN}Running command: $command${NC}"
    eval "$command"
}

# Show the header once
show_header

# Show the menu
show_menu
