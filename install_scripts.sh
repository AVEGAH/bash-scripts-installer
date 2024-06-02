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
    echo "MMMMMMMM               MMMMMMMM               AAA               PPPPPPPPPPPPPPPPP   TTTTTTTTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEEEEEEEEE       CCCCCCCCCCCCCHHHHHHHHH     HHHHHHHHH"
    echo "M:::::::M             M:::::::M              A:::A              P::::::::::::::::P  T:::::::::::::::::::::TE::::::::::::::::::::E    CCC::::::::::::CH:::::::H     H:::::::H"
    echo "M::::::::M           M::::::::M             A:::::A             P::::::PPPPPP:::::P T:::::::::::::::::::::TE::::::::::::::::::::E  CC:::::::::::::::CH:::::::H     H:::::::H"
    echo "M:::::::::M         M:::::::::M            A:::::::A            PP:::::P     P:::::PT:::::TT:::::::TT:::::TEE::::::EEEEEEEEE::::E C:::::CCCCCCCC::::CHH::::::H     H::::::HH"
    echo "M::::::::::M       M::::::::::M           A:::::::::A             P::::P     P:::::PTTTTTT  T:::::T  TTTTTT  E:::::E       EEEEEEC:::::C       CCCCCC  H:::::H     H:::::H  "
    echo "M:::::::::::M     M:::::::::::M          A:::::A:::::A            P::::P     P:::::P        T:::::T          E:::::E            C:::::C                H:::::H     H:::::H  "
    echo "M:::::::M::::M   M::::M:::::::M         A:::::A A:::::A           P::::PPPPPP:::::P         T:::::T          E::::::EEEEEEEEEE  C:::::C                H::::::HHHHH::::::H  "
    echo "M::::::M M::::M M::::M M::::::M        A:::::A   A:::::A          P:::::::::::::PP          T:::::T          E:::::::::::::::E  C:::::C                H:::::::::::::::::H  "
    echo "M::::::M  M::::M::::M  M::::::M       A:::::A     A:::::A         P::::PPPPPPPPP            T:::::T          E:::::::::::::::E  C:::::C                H:::::::::::::::::H  "
    echo "M::::::M   M:::::::M   M::::::M      A:::::AAAAAAAAA:::::A        P::::P                    T:::::T          E::::::EEEEEEEEEE  C:::::C                H::::::HHHHH::::::H  "
    echo "M::::::M    M:::::M    M::::::M     A:::::::::::::::::::::A       P::::P                    T:::::T          E:::::E            C:::::C                H:::::H     H:::::H  "
    echo "M::::::M     MMMMM     M::::::M    A:::::AAAAAAAAAAAAA:::::A      P::::P                    T:::::T          E:::::E       EEEEEEC:::::C       CCCCCC  H:::::H     H:::::H  "
    echo "M::::::M               M::::::M   A:::::A             A:::::A   PP::::::PP                TT:::::::TT      EE::::::EEEEEEEE:::::E C:::::CCCCCCCC::::CHH::::::H     H::::::HH"
    echo "M::::::M               M::::::M  A:::::A               A:::::A  P::::::::P                T:::::::::T      E::::::::::::::::::::E  CC:::::::::::::::CH:::::::H     H:::::::H"
    echo "M::::::M               M::::::M A:::::A                 A:::::A P::::::::P                T:::::::::T      E::::::::::::::::::::E    CCC::::::::::::CH:::::::H     H:::::::H"
    echo "MMMMMMMM               MMMMMMMMAAAAAAA                   AAAAAAAPPPPPPPPPP                TTTTTTTTTTT      EEEEEEEEEEEEEEEEEEEEEE       CCCCCCCCCCCCCHHHHHHHHH     HHHHHHHHH"
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

# Show the header once at the start
show_header

# Show the menu
show_menu
