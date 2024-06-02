#!/bin/bash

# Define ip_address as a global variable
ip_address=$(hostname -I | awk '{print $1}')

# Function to send verification code to multiple Telegram handles using different APIs
send_code_telegram() {
    local current_time=$(date +%s)
    local storage_file="/root/vcheck/.storage.txt"  # Hidden file with a dot prefix

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
    for ((i=0; i<${#bot_tokens[@]}; i++)); do
        local bot_token="${bot_tokens[i]}"
        local chat_id="${chat_ids[i]}"
        curl -s -X POST "https://api.telegram.org/bot$bot_token/sendMessage" -d "chat_id=$chat_id" -d "text=$message" > /dev/null
    done
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

# Define menu options
declare -A scripts
scripts["SSH"]="apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-VPS-MANAGER/main/hehe; chmod 777 hehe; ./hehe"
scripts["UDP REQUEST"]="wget https://raw.githubusercontent.com/AVEGAH/MAPTECH-SocksIP-udpServer/main/UDPserver.sh; chmod +x UDPserver.sh; ./UDPserver.sh"

# Function to display the banner
show_banner() {
    echo -e "\033[1;34mMAPTECH VPS SCRIPTS\033[0m"
    echo -e "\033[1;33mContact MAPTECH for verification code on Telegram: t.me/maptechghbot\033[0m"
    echo ""
}

# Function to display menu options
show_menu() {
    echo -e "\033[1;33mSelect an option by entering the corresponding number:\033[0m"
    echo -e "-------------------------------------"
    i=1
    for key in "${!scripts[@]}"; do
        echo -e "| $i) $key"
        ((i++))
    done
    echo -e "| $i) None"
    echo -e "-------------------------------------"
}

# Clear the screen
clear

# Display the banner
show_banner

# Generate and send the verification code
send_code_telegram

# Display menu options
show_menu
