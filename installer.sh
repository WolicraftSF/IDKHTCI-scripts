#!/bin/bash

if [[ $EUID -eq 0 ]]; then
   echo "Running as root is not supported" 
   exit 1
fi

if [ $# -gt 1 ]; then
    echo "Error: too many arguments."
    exit 1
fi
installOption=$1

installersLocation="https://raw.githubusercontent.com/WolicraftSF/IDKHTCI-scripts/refs/heads/main/installers/"

if [ $(curl -fsSL "${installersLocation}/${installOption}.sh" > /dev/null; echo $?) -ne 0 ]; then
    echo -e "${RED}[!] Invalid URL (${installersLocation}/${installOption}.sh)\a"
    exit 1
fi

#color codes for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color
bold=$(tput bold)
normal=$(tput sgr0)

#checking dependencies
#which realpath ; echo $?

#3 args, question text and the yes and no commands
yesno()
{
    local question=$1
    local yesCommands=$2
    local noCommands=$3
    while true
    do
        echo -en "$(eval "echo $question") \a"
        echo -en "${bold}[${GREEN}Y${NC}/${RED}n${NC}] "; read choiceRead </dev/tty

        if [[ "$choiceRead" == [yY] || "$choiceRead" == [yY][eE][sS] ]]; then
            eval $yesCommands
            yesnoResult=1
            break
        elif [[ "$choiceRead" == [nN] || "$choiceRead" == [nN][oO] ]]; then
            eval $noCommands
            yesnoResult=0
            break
        else
            echo -e "${RED}[!] Invalid Option\a"
        fi
    done
}

echo -en "${GREEN}[*] ${NC}Select a directory to download the installer. A folder inside it will be created. [default: $HOME/]: "; read -e targetDir </dev/tty
if [[ "$targetDir" == "" ]]; then
    yesno '${RED}[!] ${NC}Use default directory?' \
    'targetDir=$HOME/' \
    'echo -e "${RED}[!] Aborted\a"; exit'
fi
exit

targetDir="$(eval echo $targetDir)"
targetDir=$(realpath -Ls "$targetDir")
if [ ! -d $targetDir ]; then
    echo -e "${RED}[!] $targetDir is not a directory \a"
    exit
fi

echo -e "${GREEN}[*] ${NC}Using ${BLUE}"$targetDir"${NC} for the download"
targetDir=$targetDir/IDKHTCI-dl
mkdir $targetDir
cd $targetDir

source <(curl -fsSL "${installersLocation}/${installOption}.sh")

echo -e "${GREEN}[*] ${BLUE}Downloading ${}..."
downloadInstructions

echo -e "${GREEN}[*] ${BLUE}Installing..."
installInstructions

cd $targetDir
echo -e "${GREEN}[*] Install Successful!"

aditionalInstructions

yesno '${RED}[!] ${NC}Do you want to remove the installer? (Installation will be kept)' \
'echo -e "${RED}[!] ${BLUE}Removing installer files..."; rm -r ${targetDir}' \
''

echo -e "${GREEN}[*] Done!"