#!/bin/bash
downloadInstructions()
{
    git clone https://github.com/JafarAkhondali/acer-predator-turbo-and-rgb-keyboard-linux-module.git
}

installInstructions()
{
    cd "acer-predator-turbo-and-rgb-keyboard-linux-module"
    chmod +x ./*.sh
    sudo ./install_service.sh
}

aditionalInstructions()
{
    aditionalOptions=3
    echo -e "${BLUE} [ADITIONAL TWEAKS]"
    for i in $(eval echo "{1..$aditionalOptions}")
    do
        case $i in
            1)
                echo "yesno"
                yesno '${BLUE}[&] ${NC}Make command "facer-rgb" available outside its directory? ${RED}[SUDO REQUIRED]' \
                'sudo curl -fsSL ${installersLocation}/${installOption}_additional/facer-rgb_usrbin.sh -o /usr/bin/facer-rgb; sudo chmod +x /usr/bin/facer-rgb' \
                '';;
            2)
                yesno '${BLUE}[&] ${NC}Apply fix on root home directory? ${GREEN}[Recommended: yes] ${RED}[SUDO REQUIRED]' \
                'sudo rm -rf /root/.config/predator; sudo -E ln -s $HOME/.config/predator /root/.config/predator' \
                '';;
            3)
                yesno '${BLUE}[&] ${NC}Add rebuilder script to root directory[/]? ${RED}[SUDO REQUIRED]' \
                'sudo curl -fsSL ${installersLocation}/${installOption}_additional/rebuilder.sh -o /rebuild_acer-rgb.sh; sudo chmod +x /rebuild_acer-rgb.sh' \
                '';;
        esac
        
        if [ $yesnoResult -eq 1 ]; then
            echo -e "${GREEN}[*] ${NC}Custom option successfully aplied!"
        else
            echo -e "${BLUE}[*] ${NC}Skipping custom option"
        fi
    done
}