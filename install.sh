#!/bin/bash

set -e


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

MANGE_INSTALLATIONS_PATH="/usr/local/bin/manage_installations.sh"

# Check if manage_installations is an updated symlink, if is not or is a file remove it and 
# create the symlinks again

if [ -e "$MANGE_INSTALLATIONS_PATH" ]; then
    if [ -L "$MANGE_INSTALLATIONS_PATH" ]; then
        if [ "$(readlink $MANGE_INSTALLATIONS_PATH)" != "$BASE_DESTIANTION/.config/scripts/manage_installations.sh" ]; then
           sudo rm "$MANGE_INSTALLATIONS_PATH"
           sudo ln -s "$BASE_DESTIANTION/.config/scripts/manage_installations.sh" "$MANGE_INSTALLATIONS_PATH"
        fi
    else
       sudo rm "$MANGE_INSTALLATIONS_PATH"
       sudo ln -s "$BASE_DESTIANTION/.config/scripts/manage_installations.sh" "$MANGE_INSTALLATIONS_PATH"
    fi
else
 sudo ln -s "$BASE_DESTIANTION/.config/scripts/manage_installations.sh" "$MANGE_INSTALLATIONS_PATH"
fi

#Check if manage_nvim has execute permission, if not add it
if [ ! -x "/usr/local/bin/manage_installations.sh" ]; then
   sudo chmod +x "/usr/local/bin/manage_installations.sh"
fi

UPDATE_INSTALLATIONS_PATH="/etc/apt/apt.conf.d/99update-installations"

if [ -e "$UPDATE_INSTALLATIONS_PATH" ]; then
    if [ -L "$UPDATE_INSTALLATIONS_PATH" ]; then
        if [ "$(readlink $UPDATE_INSTALLATIONS_PATH)" != "$BASE_DESTIANTION/.config/scripts/apt/99update-installations" ]; then
           sudo rm "$UPDATE_INSTALLATIONS_PATH"
           sudo ln -s "$BASE_DESTIANTION/.config/scripts/apt/99update-installations" "$UPDATE_INSTALLATIONS"
        fi
    else
       sudo rm "$UPDATE_INSTALLATIONS_PATH"
       sudo ln -s "$BASE_DESTIANTION/.config/scripts/apt/99update-installations" "$UPDATE_INSTALLATIONS_PATH"
    fi
else
  sudo ln -s "$BASE_DESTIANTION/.config/scripts/apt/99update-installations" "$UPDATE_INSTALLATIONS_PATH"
fi



