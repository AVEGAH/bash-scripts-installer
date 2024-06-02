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
    echo -e "${BLUE}INTERNET-DOCTORS VPS SCRIPTS, please select an option:${NC}"
    echo -e "${BLUE}┌────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│ ${YELLOW}SSH Installation                                                 ${BLUE}│${NC}"
    echo -e "${BLUE}│ ${YELLOW}UDP Request Installation                                         ${BLUE}│${NC}"
    echo -e "${BLUE}│ ${YELLOW}Quit                                                            ${BLUE}│${NC}"
    echo -e "${BLUE}└────────────────────────────────────────────────────────────────────┘${NC}"
    PS3="Enter your choice: "
    select option in "SSH Installation" "UDP Request Installation" "Quit"; do
        case $option in
            "SSH Installation")
                if [[ -n "${scri
