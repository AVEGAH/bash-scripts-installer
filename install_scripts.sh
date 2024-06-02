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

# Telegram bot token and chat ID
bot_token="6803390472:AAEEX8hpTFhsxbmzU5oiZD4dYCOKxS4-lCE"
chat_id="5989863155"

# Function to clear screen
clear_screen() {
    clear
}

# Function to send verification code to Telegram
send_code_telegram() {
    local current_time=$(date +%s)
    local storage_file="/root/vcheck/.storage.txt"  # Hidden file with a dot prefix
    local ip_address=$(hostname -I | awk '{print $1}')

    # Check if the vcheck folder exists, if not create it
    if [[ ! -d "/root/vcheck" ]]; then
        mkdir -p /root/vcheck
    fi

    # Check if the storage file exists, if not create it
    if [[ ! -f "$storage_file" ]]; then
        touch "$storage_file"
        chmod 600 "$storage_file"  # Restrict permissions for security
    fi

    # Check if there's a recent request from the same IP address
    local last_sent_code=$(awk -v ip="$ip_address" '$1 == ip {print $2}' "$storage_file")
    local last_sent_time=$(awk -v ip="$ip_address" '$1 == ip {print $3}' "$storage_file")

    # Adjust the time interval here (e.g., 600 for 10 minutes)
    if [[ -n "$last_sent_code" && $((current_time - last_sent_time)) -lt 3600 ]]; then
        # Calculate remaining time in seconds
        local time_left=$((3600 - (current_time - last_sent_time)))

        # Convert remaining time to minutes and seconds
        local minutes=$((time_left / 60))
        local seconds=$((time_left % 60))

        # Display the message with the remaining time
        echo -e "\033[1;36m======================================================================================\033[0m"
        echo -e "\033[1;31m  CODE SENT ALREADY! YOU HAVE $minutes MINUTES AND $seconds SECONDS LEFT TO REDEEM IT \033[0m"
        echo -e "\033[1;36m======================================================================================\033[0m"
        echo ""
        echo -e "\033[1;32m              @maptechgh_bot  \033[0m on Telegram"
        echo ""
        echo -e "\033[1;36m======================================================================================\033[0m"
        echo ""
        return
    fi

    # Generate random 6-digit code
    local random_code=$(shuf -i 100000-999999 -n 1)

    # Store the code along with the IP address and timestamp
    echo "$ip_address $random_code $current_time" > "$storage_file"

    # Send message to Telegram
    local message="The verification code for $ip_address is: $random_code"
    curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" -d "chat_id=$chat_id" -d "text=$message" > /dev/null

    echo -e "\033[1;36m=============================================================\033[0m"
    echo -e "\033[1;31m       CONTACT TEAM MAPTECH FOR VERIFICATION CODE\033[0m"
    echo -e "\033[1;36m==============================================================\033[0m"
    echo ""
    echo -e "\033[1;32m              @maptechgh_bot  \033[0m on Telegram"
    echo ""
    echo -e "\033[1;36m=============================================================\033[0m"
    echo ""
    echo -e "\033[1;31m  Price is $1 & GH₵10 for the code with a validity period of 60 mins \033[0m"
    echo ""
}

# Function to run the selected script
install_script() {
    local command=$1
    echo -e "${GREEN}Running command: $command${NC}"
    eval "$command"
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

# Function to show the options menu
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

# Function to prompt user for option selection
prompt_for_option() {
    read -p "Enter the number corresponding to your choice: " option_number
    if [[ $option_number =~ ^[0-9]+$ ]]; then
        if (( option_number > 0 && option_number <= (${#scripts[@]} + 1) )); then
            return $option_number
        fi
    fi
    return 0
}

# Function to run the selected script
run_selected_script() {
    local option_number=$1
    if (( option_number <= ${#scripts[@]} )); then
        i=1
        for key in "${!scripts[@]}"; do
            if ((
