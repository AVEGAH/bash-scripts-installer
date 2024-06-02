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

# Function to run the selected script
install_script() {
    local command=$1
    echo -e "${GREEN}Running command: $command${NC}"
    eval "$command"
}

# Show the header once at the start
show_header

# Show the table for option selection
show_options() {
    echo -e "${YELLOW}Select an option:${NC}"
    echo -e "--------------------------------------------------"
    for key in "${!scripts[@]}"; do
        printf "| %-15s | %s\n" "$key" "${scripts[$key]}"
    done
    echo -e "--------------------------------------------------"
}

# Run the selected script
if [[ $1 ]]; then
    case $1 in
        "SSH")
            if [[ -n "${scripts["SSH"]}" ]]; then
                install_script "${scripts["SSH"]}"
            else
                echo -e "${RED}Invalid option. Try again.${NC}"
            fi
            ;;
        "UDP Request")
            if [[ -n "${scripts["UDP REQUEST"]}" ]]; then
                install_script "${scripts["UDP REQUEST"]}"
            else
                echo -e "${RED}Invalid option. Try again.${NC}"
            fi
            ;;
        *)
            echo -e "${RED}Invalid option. Try again.${NC}"
            ;;
    esac
else
    show_options
fi
