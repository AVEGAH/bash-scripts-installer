#!/bin/bash

# Telegram bot token and chat ID
BOT_TOKEN="7380565425:AAFFIJ_GOhqWkC4ANzQTEiR06v6CBXtlL7g"
CHAT_ID="5989863155"

# Function to send message via Telegram
send_telegram_message() {
    local message="$1"
    local url="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"
    local data="chat_id=$CHAT_ID&text=$message"
    curl -s -d "$data" "$url" > /dev/null
}

# Function to send verification code via Telegram
send_verification_code() {
    # Generate random 6-digit verification code
    verification_code=$(shuf -i 100000-999999 -n 1)

    # Get server IP address
    server_ip=$(hostname -I | grep -Eo '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | grep -vE '^127(\.[0-9]{1,3}){3}|^10(\.[0-9]{1,3}){3}|^192\.168(\.[0-9]{1,3}){2}|^172\.(1[6-9]|2[0-9]|3[0-1])(\.[0-9]{1,3}){2}')

    # Send verification code and IP address via Telegram
    send_telegram_message "Your verification code is: $verification_code. Server IP: $server_ip"
}

# Function to clear screen
clear_screen() {
    clear
}

# ASCII Art Header
show_header() {
    clear_screen
    echo -e "${BLUE}"
    echo "   ███╗   ███╗ █████╗ ██████╗ ████████╗███████╗ ██████╗██╗  ██╗"
    echo "   ████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔════╝██║  ██║"
    echo "   ██╔████╔██║███████║██████╔╝   ██║   █████╗  ██║     ███████║"
    echo "   ██║╚██╔╝██║██╔══██║██╔═══╝    ██║   ██╔══╝  ██║     ██╔══██║"
    echo "   ██║ ╚═╝ ██║██║  ██║██║        ██║   ███████╗╚██████╗██║  ██║"
    echo "   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${NC}"
}

# Function to run the selected script or action
execute_action() {
    local action=$1
    case $action in
        "send_verification_code")
            send_verification_code
            ;;
        *)
            if [[ ${scripts[$action]} ]]; then
                install_script "${scripts[$action]}"
            else
                echo -e "${RED}Invalid action.${NC}"
            fi
            ;;
    esac
}

# Function to run the selected script
install_script() {
    local command=$1
    echo -e "${GREEN}Running command: $command${NC}"
    eval "$command"
}

# Function to install the selected script
install_selected_script() {
    show_header
    echo -e "${YELLOW}Select an option to install:${NC}"
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
    else
        echo -e "${RED}Invalid option number.${NC}"
        exit 1
    fi
}

# Show the table for option selection
show_options() {
    echo -e "-------------------------------------"
    i=1
    for key in "${!scripts[@]}"; do
        echo "| $i) $key"
        ((i++))
    done
    echo -e "-------------------------------------"
}

# Prompt user for option selection
prompt_for_option() {
    read -p "Enter the number corresponding to your choice: " option_number
    if [[ $option_number =~ ^[0-9]+$ ]]; then
        if (( option_number > 0 && option_number <= ${#scripts[@]} )); then
            return $option_number
        fi
    fi
    return 0
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define the list of commands
declare -A scripts
scripts["SSH"]="apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe"
scripts["UDP REQUEST"]="wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-SocksIP-udpServer/main/UDPserver.sh; chmod +x UDPserver.sh; ./UDPserver.sh"

# Show the header once at the start
show_header

# Send verification code via Telegram
send_verification_code
