#!/bin/bash

# Define the list of commands
declare -A scripts
scripts["SSH"]="apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe"
scripts["UDP REQUEST"]="wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-SocksIP-udpServer/main/UDPserver.sh; chmod +x UDPserver.sh; ./UDPserver.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII Art Header
show_header() {
    echo -e "${BLUE}"
    echo "███╗   ███╗ █████╗ ██████╗ ████████╗███████╗ ██████╗██╗  ██╗"
    echo "████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔════╝██║  ██║"
    echo "██╔████╔██║███████║██████╔╝   ██║   █████╗  ██║     ███████║"
    echo "██║╚██╔╝██║██╔══██║██╔═══╝    ██║   ██╔══╝  ██║     ██╔══██║"
    echo "██║ ╚═╝ ██║██║  ██║██║        ██║   ███████╗╚██████╗██║  ██║"
    echo "╚═╝     ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${NC}"
}

# Function to display the menu
show_menu() {
    echo -e "${YELLOW}Welcome to Internet Doctors VPS Scripts. Please select an option:${NC}"
    echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
    echo -e "${GREEN}1${NC}) ${YELLOW}SSH Installation${NC}"
    echo -e "${GREEN}2${NC}) ${YELLOW}UDP Request Installation${NC}"
    echo -e "${GREEN}3${NC}) ${YELLOW}Quit${NC}"
    echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
    PS3="Enter your choice: "
    select option in "SSH Installation" "UDP Request Installation" "Quit"; do
        case $option in
            "SSH Installation")
                if [[ -n "${scripts["SSH"]}" ]]; then
                    install_script "${scripts["SSH"]}"
                else
                    echo -e "${RED}Invalid option. Try again.${NC}"
                fi
                ;;
            "UDP Request Installation")
                if [[ -n "${scripts["UDP REQUEST"]}" ]]; then
                    install_script "${scripts["UDP REQUEST"]}"
                else
                    echo -e "${RED}Invalid option. Try again.${NC}"
                fi
                ;;
            "Quit")
                echo -e "${RED}Exiting.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Try again.${NC}"
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

# Show the header once at the start
show_header

# Show the menu
show_menu
