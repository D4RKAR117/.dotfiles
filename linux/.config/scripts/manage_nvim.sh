#!/bin/bash

# Function to compare versions
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Get the current installed version of Neovim
if command -v nvim &> /dev/null; then
    current_nvim_version=$(nvim --version | head -n 1 | awk '{print $2}')
else
    current_nvim_version="0.0.0"
fi

# Get the latest version from GitHub releases
latest_nvim_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Compare versions and update if necessary
if version_gt "$latest_nvim_version" "$current_nvim_version"; then
    echo "Updating Neovim from version $current_nvim_version to $latest_nvim_version..."

    # Download the latest Neovim release
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -O /tmp/nvim-linux64.tar.gz

    # Extract the downloaded archive
    tar xzf /tmp/nvim-linux64.tar.gz -C /tmp


    # Remove the old Neovim directory
    sudo rm -rf /usr/local/nvim

    # Move the extracted files to the appropriate directory
    sudo mv /tmp/nvim-linux64 /usr/local/nvim

    # Create a symbolic link
    sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim

    # Clean up
    rm /tmp/nvim-linux64.tar.gz

    echo "Neovim updated successfully to version $latest_nvim_version."
else
    echo "Neovim is already up-to-date (version $current_nvim_version)."
fi

if command -v starship &> /dev/null; then
  current_starship_version=$(starship -V | awk '{print $2}')
else
  current_starship_version="0.0.0"
fi

latest_starship_version=$(curl -s https://api.github.com/repos/starship/starship/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# trim the "v" from the version number
latest_starship_version="${latest_starship_version//v}"

if version_gt "$latest_starship_version" "$current_starship_version"; then
    echo "Updating Starship from version $current_starship_version to $latest_starship_version..."
    # Download the latest Starship release
    curl -sS https://starship.rs/install.sh | sh
    
    echo "Starship updated successfully to version $latest_starship_version."
else
  echo "Starship is already up-to-date (version $current_starship_version)."
fi
