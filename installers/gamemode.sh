#!/bin/bash
downloadInstructions()
{
    git clone https://github.com/FeralInteractive/gamemode.git
}

installInstructions()
{
    cd gamemode
    ./bootstrap.sh
    gamemoded -t
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Tests failed. Sudo is required\a"
        sudo usermod -a -G gamemode $USER
        gamemoded -t
    fi
}

aditionalInstructions()
{
    aditionalOptions=1
    echo -e "${BLUE} [ADITIONAL TWEAKS]"
    for i in $(eval echo {1..$aditionalOptions})
    do
        case $i in
            1)
                yesno '${BLUE}[&] ${NC}Use NVIDIA GPU environment variables when running on gamemode?' \
                'echo 'export GAMEMODERUNEXEC="env __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=non_NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia"' >> ~/.bashrc' \
                '';;
        esac
        
        if [ yesnoResult -eq 1 ]; then
            echo -e "${GREEN}[*] ${NC}Custom option successfully aplied!"
        else
            echo -e "${BLUE}[*] ${NC}Skipping custom option"
        fi
    done
}