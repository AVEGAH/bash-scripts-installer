#!/bin/bash

# Telegram bot token and chat ID
BOT_TOKEN="7380565425:AAFFIJ_GOhqWkC4ANzQTEiR06v6CBXtlL7g"
CHANNEL_ID="-1002148915754"  # Your Telegram channel ID

# Define the list of commands
declare -A scripts
scripts["SSH"]="apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe"
scripts["UDP REQUEST"]="wget https://raw.githubusercontent.com/AVEGAH/SocksIP-udpServer/main/UDPserver.sh; chmod +x UDPserver.sh; ./UDPserver.sh"
scripts["hiddify"]="bash <(curl -Ls https://raw.githubusercontent.com/ozipoetra/z-ui/main/install.sh)"
scripts["auto script"]="sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/AVEGAH/AutoScriptXray/master/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh"
scripts["Udp custom"]="git clone https://github.com/AVEGAH/Udpcustom.git && cd Udpcustom && chmod +x install.sh && ./install.sh"
scripts["Udp hysteria"]="wget https://github.com/khaledagn/AGN-UDP/raw/main/install_agnudp.sh; chmod +x install_agnudp.sh; ./install_agnudp.sh; nano /etc/hysteria/config.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verification storage directory and file
VCHECK_DIR="/root/vcheck"
VCHECK_FILE="$VCHECK_DIR/.storage.txt"

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
        "cancel")
            echo -e "${YELLOW}Installation canceled.${NC}"
            exit 0
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

# Function to send message via Telegram including IPv4 address
send_telegram_message() {
    local message="$1"
    local url="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"
    local data="chat_id=$CHANNEL_ID&text=$message"
    curl -s -d "$data" "$url" > /dev/null
}

# Function to send verification code via Telegram
send_verification_code() {
    # Generate random 6-digit verification code
    verification_code=$(shuf -i 100000-999999 -n 1)

    # Get the IPv4 address
    ipv4_address=$(hostname -I | awk '{print $1}')

    # Create the vcheck directory and storage file if they do not exist
    mkdir -p "$VCHECK_DIR"
    touch "$VCHECK_FILE"
    chmod 600 "$VCHECK_FILE"  # Restrict permissions for security

    local current_time=$(date +%s)

    # Check if there's a recent request from the same IP address
    local last_sent_code=$(awk -v ip="$ipv4_address" '$1 == ip {print $2}' "$VCHECK_FILE")
    local last_sent_time=$(awk -v ip="$ipv4_address" '$1 == ip {print $3}' "$VCHECK_FILE")

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
        echo -e "\033[1;32m              t.me/wmaptechvpsscriptbot  \033[0m on Telegram"
        echo ""
        echo -e "\033[1;36m======================================================================================\033[0m"
        echo ""
        read -p "Enter the verification code received: " user_code
        check_verification_code "$user_code"
        return
    fi

    # Send verification code via Telegram
    send_telegram_message "The verification code for $ipv4_address is: $verification_code"

    # Display contact information for verification code
    echo -e "\033[1;36m==============================================================\033[0m"
    echo -e "\033[1;31m          ALL IN ONE VPS SCRIPT INSTALLATION\033[0m"
    echo -e "\033[1;36m==============================================================\033[0m"
    echo ""
    echo -e "\033[1;32m              t.me/wmaptechvpsscriptbot  \033[0m on Telegram"
    echo ""
    echo -e "\033[1;36m==============================================================\033[0m"
    echo ""
    echo -e "\033[1;31m  Get the verification code from our telegram bot {T & C}  \033[0m"
    echo ""

    # Prompt user for verification code
    read -p "Enter the verification code received: " user_code

    # Check if user entered the correct verification code
    if [[ "$user_code" == "$verification_code" ]]; then
        echo -e "${GREEN}Verification successful.${NC}"
        # Store the code along with the IP address and current time in the storage file
        echo "$ipv4_address $verification_code $current_time" >> "$VCHECK_FILE"
        install_selected_script
    else
        echo -e "${RED}Incorrect verification code.${NC}"
        send_verification_code
    fi
}

# Function to check the verification code entered by the user
check_verification_code() {
    local user_code=$1
    local stored_code=$(awk -v ip="$ipv4_address" '$1 == ip {print $2}' "$VCHECK_FILE")
    if [[ "$user_code" == "$stored_code" ]]; then
        echo -e "${GREEN}Verification successful.${NC}"
        install_selected_script
    else
        echo -e "${RED}Incorrect verification code.${NC}"
        send_verification_code
    fi
}

# Function to install the selected script
install_script() {
    local command=$1
    eval "$command"
}

# Function to display the menu options
show_options() {
    echo "1) SSH"
    echo "2) UDP REQUEST"
    echo "3) hiddify"
    echo "4) auto script"
    echo "5) Udp custom"
    echo "6) Udp hysteria"
    echo "7) Cancel"
}

# Function to prompt for menu option
prompt_for_option() {
    read -p "Enter the number corresponding to your choice: " option
    return $option
}

# Function to install the selected script
install_selected_script() {
    show_header
    echo -e "${YELLOW}Select an option to install:${NC}"
    show_options
    prompt_for_option
    option_number=$?

# Function to install the selected script
install_selected_script() {
    show_header
    echo -e "${YELLOW}Select an option to install:${NC}"
    show_options
    prompt_for_option
    option_number=$?
    if (( option_number > 0 && option_number <= ${#scripts[@]} + 1 )); then
        i=1
        for key in "${!scripts[@]}"; do
            if (( i == option_number )); then
                install_script "${scripts[$key]}"
            fi
            ((i++))
        done
        if (( option_number == ${#scripts[@]} + 1 )); then
            execute_action "cancel"
        fi
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
    echo "| $i) Cancel"
    echo -e "-------------------------------------"
}

# Prompt user for option selection
prompt_for_option() {
    read -p "Enter the number corresponding to your choice: " option_number
    if [[ $option_number =~ ^[0-9]+$ ]]; then
        if (( option_number > 0 && option_number <= ${#scripts[@]} + 1 )); then
            return $option_number
        fi
    fi
    return 0
}

# Show the header once at the start
show_header

# Send verification code via Telegram
send_verification_code
