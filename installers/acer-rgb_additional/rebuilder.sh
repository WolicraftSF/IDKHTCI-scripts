#!/bin/bash
#Disclaimer: this rebuilder was vibe coded. A new one is planned.

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "[!] This script must be run as root."
    exit 1
fi

# Define the working directory
MODULE_DIR="/opt/turbo-fan"
INSTALL_LOG="/var/log/facer_install.log"

# Check if the module directory exists
if [[ ! -d "$MODULE_DIR" ]]; then
    echo "[!] Module directory $MODULE_DIR does not exist."
    exit 1
fi

# Navigate to the module directory
cd "$MODULE_DIR" || {
    echo "[!] Failed to change to directory $MODULE_DIR."
    exit 1
}

# Log the rebuild process
echo "[*] Rebuilding module at $(date)" | tee -a "$INSTALL_LOG"

# Clean the previous build
echo "[*] Cleaning previous build artifacts..." | tee -a "$INSTALL_LOG"
make clean >> "$INSTALL_LOG" 2>&1
if [[ $? -ne 0 ]]; then
    echo "[!] Failed to clean build artifacts. Check $INSTALL_LOG for details."
    exit 1
fi

# Build and install the module
echo "[*] Building the kernel module..." | tee -a "$INSTALL_LOG"
make install >> "$INSTALL_LOG" 2>&1
if [[ $? -ne 0 ]]; then
    echo "[!] Build failed. Check $INSTALL_LOG for details."
    exit 1
fi

# Run the installation script
echo "[*] Running install.sh..." | tee -a "$INSTALL_LOG"
bash install.sh >> "$INSTALL_LOG" 2>&1
if [[ $? -ne 0 ]]; then
    echo "[!] Installation script failed. Check $INSTALL_LOG for details."
    exit 1
fi

# Verify if the module is loaded
MODULE_NAME="facer"
if lsmod | grep -q "$MODULE_NAME"; then
    echo "[*] Module $MODULE_NAME successfully loaded!" | tee -a "$INSTALL_LOG"
else
    echo "[!] Module $MODULE_NAME could not be loaded. Check dmesg for errors."
    dmesg | tail -n 20
    exit 1
fi

echo "[*] Rebuild and installation completed successfully!" | tee -a "$INSTALL_LOG"
exit 0