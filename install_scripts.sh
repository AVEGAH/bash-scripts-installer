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

# Function to clear screen
clear_screen() {
    clear
}

# ASCII Art Header
show_header() {
    clear_screen
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
    echo -e "${YELLOW}Select an option by entering the corresponding number:${NC}"
    echo -e "-------------------------------------"
    i=1
    for key in "${!scripts[@]}"; do
        echo "| $i) $key"
        ((i++))
    done
    echo "| $i) None"
    echo -e "-------------------------------------"
}

# Prompt user for option selection
prompt_for_option() {
    read -p "Enter the number corresponding to your choice: " option_number
    if [[ $option_number =~ ^[0-9]+$ ]]; then
        if (( option_number > 0 && option_number <= (${#scripts[@]} + 1) )); then
            return $option_number
        fi
    fi
    return 0
}

# Run the selected script
if [[ $1 ]]; then
    case $1 in
        [0-9]*)
            option_number=$1
            if (( option_number > 0 && option_number <= (${#scripts[@]} + 1) )); then
                if (( option_number <= ${#scripts[@]} )); then
                    i=1
                    for key in "${!scripts[@]}"; do
                        if (( i == option_number )); then
                            install_script "${scripts[$key]}"
                            exit 0
                        fi
                        ((i++))
                    done
                else
                    echo "None selected."
                    exit 0
                fi
            else
                echo -e "${RED}Invalid option number.${NC}"
            fi
            ;;
        *)
            echo -e "${RED}Invalid option. Try again.${NC}"
            ;;
    esac
else
    show_options
    prompt_for_option
    option_number=$?
    if (( option_number > 0 && option_number <= ${#scripts[@]} )); then
        i=1
        for key in "${!scripts[@]}"; do
            if (( i == option_number )); then
                install_script "${scripts[$key]}"
                exit 0
            fi
            ((i++))
        done
    elif (( option_number == ${#scripts[@]} + 1 )); then
        echo "None selected."
        exit 0
    else
        echo -e "${RED}Invalid option number.${NC}"
    fi
fi
