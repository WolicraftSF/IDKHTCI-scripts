#!/bin/bash

#color codes for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color
bold=$(tput bold)
normal=$(tput sgr0)

#note: printf is like echo -e but without the \n
printf "${GREEN}[*] ${NC}Select a directory to download the installer [default: $HOME/]: "; read -e targetDir </dev/tty
if [[ "$targetDir" == "" ]]; then
    while true
    do
        printf "${RED}[!] ${NC}Use default directory? \a"
        printf "${bold}[${GREEN}Y${NC}/${RED}n${NC}] "; read choiceRead </dev/tty

        if [[ "$choiceRead" == [yY] || "$choiceRead" == [yY][eE][sS] ]]; then
            targetDir=$HOME
            break
        elif [[ "$choiceRead" == [nN] || "$choiceRead" == [nN][oO] ]]; then
            echo -e "${RED}[!] Aborted\a"
            exit
        else
            echo -e "${RED}[!] Invalid Option\a"
        fi
    done
fi

targetDir="${targetDir/#\~/$HOME}"
targetDir=$(realpath -Ls "$targetDir")
if [ ! -d $targetDir ]; then
    echo -e "${RED}[!] $targetDir is not a directory\a"
    exit
fi
echo -e "${GREEN}[*] ${NC}Using ${BLUE}"$targetDir"${NC} for the download"

echo -e "${GREEN}[*] ${BLUE}Cloning repository..."
cd $targetDir
git clone https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module.git

echo -e "${GREEN}[*] ${BLUE}Installing..."
cd "acer-predator-turbo-and-rgb-keyboard-linux-module"
chmod +x ./*.sh
sudo ./install_service.sh

cd $targetDir
echo -e "${GREEN}[*] Install Successful!"

echo -e "${RED}[!] ${NC}Do you want to remove the installer? (Installation will be kept)\a"
while true
do
    printf "${bold}[${GREEN}Y${NC}/${RED}n${NC}] "; read choiceRead </dev/tty
    if [[ "$choiceRead" == [yY] || "$choiceRead" == [yY][eE][sS] ]]; then
        echo -e "${RED}[!] ${BLUE}Removing installer files..."
        rm -r "acer-predator-turbo-and-rgb-keyboard-linux-module"
        break
    elif [[ "$choiceRead" == [nN] || "$choiceRead" == [nN][oO] ]]; then
        break
    else
        echo -e "${RED}[!] Invalid Option\a"
    fi
done

echo -e "${GREEN}[*] Done!"