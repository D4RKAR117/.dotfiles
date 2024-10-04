#!/bin/bash

set -eux



BASE_DESTIANTION="$HOME"
BASE_ORIGIN="$BASE_DESTIANTION/.dotfiles/linux"


echo "Installing dotfiles..."

echo "Checking if stow is installed..."

if ! [ -x "$(command -v stow)" ]; then
    echo "Stow is not installed. Installing stow..."
    sudo apt-get install stow
fi
# Use stow to create symlinks

stow --dir="$BASE_ORIGIN" --target="$BASE_DESTIANTION" --dotfiles --restow . --adopt

# Manual link the non relative files

# Check if the file exists and is a symlink to the desired location, if not delete it before creating the new symlink
# If the file exists and is not a symlink, make a backup before deleting it with the .bak extension


MANGE_NVIM_PATH="/usr/local/bin/manage_nvim.sh"

if [ -e "$MANGE_NVIM_PATH" ]; then
    if [ -L "$MANGE_NVIM_PATH" ]; then
        if [ "$(readlink $MANGE_NVIM_PATH)" != "$BASE_DESTIANTION/.config/scripts/manage_nvim.sh" ]; then
            sudo rm "$MANGE_NVIM_PATH"
        fi
    else
        sudo mv "$MANGE_NVIM_PATH" "$MANGE_NVIM_PATH.bak"
    fi
fi

sudo ln -s "$BASE_DESTIANTION/.config/scripts/manage_nvim.sh" "/usr/local/bin/manage_nvim.sh"

#Check if manage_nvim has execute permission, if not add it
if [ ! -x "/usr/local/bin/manage_nvim.sh" ]; then
   sudo chmod +x "/usr/local/bin/manage_nvim.sh"
fi

UPDATE_NVIM_PATH="/etc/apt/apt.conf.d/99update-nvim"

if [ -e "$UPDATE_NVIM_PATH" ]; then
    if [ -L "$UPDATE_NVIM_PATH" ]; then
        if [ "$(readlink $UPDATE_NVIM_PATH)" != "$BASE_DESTIANTION/.config/scripts/apt/99update-nvim" ]; then
           sudo rm "$UPDATE_NVIM_PATH"
        fi
    else
       sudo mv "$UPDATE_NVIM_PATH" "$UPDATE_NVIM_PATH.bak"
    fi
fi

sudo ln -s "$BASE_DESTIANTION/.config/scripts/apt/99update-nvim" "/etc/apt/apt.conf.d/99update-nvim"


