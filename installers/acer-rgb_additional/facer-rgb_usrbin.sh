#!/bin/bash
argnum=$#
if [ $argnum -gt 1 ] && [[ "$1" == "-m" || "$1" == "--manual" ]]; then
    text=""
    for i in $(eval echo {2..$argnum})
    do
        text="$text $(eval echo \$$i)"
    done
    python /opt/turbo-fan/facer_rgb.py $text
    exit
fi

if [ $argnum -gt 1 ]; then
    echo "Error: too many arguments."
    exit 1
elif [ $argnum -eq 1 ]; then
    case $1 in
        "--manual"|"-m")
            echo -en "Options ([-h] for help): "
            read -e option </dev/tty
            python /opt/turbo-fan/facer_rgb.py $option;;
        "--help"|"-h")
            echo -e \
            "Usage: facer-rgb [OPTIONS]\nChange keyboard color on Acer laptops.\n\
            \n\
              Options:\n\
                --manual, -m  Use without an interface. Allows to save and load color profiles.\n\
                --help,   -h  Show this help message.";;
        *)
            echo "Error: invalid argument.";;
    esac
else
    python /opt/turbo-fan/keyboard.py
fi