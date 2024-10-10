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


if command -v lazygit &> /dev/null; then
  # Get the current installed version of Lazygit looking for first "version=0.0.0" on the output
  # the output string ignoring "git version=0.0.0" due to beign present afterwards
  current_lazygit_version=$(lazygit --version  | grep -oP 'version=\K[^ ]+' | head -n 1)
  # trim any , 
  current_lazygit_version="${current_lazygit_version//,}"
else
  current_lazygit_version="0.0.0"
fi

latest_lazygit_version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*')

if version_gt "$latest_lazygit_version" "$current_lazygit_version"; then
    echo "Updating Lazygit from version $current_lazygit_version to $latest_lazygit_version..."
    # Download the latest Lazygit release
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${latest_lazygit_version}_Linux_x86_64.tar.gz"
    tar xzf lazygit.tar.gz lazygit

    # Remove the old Lazygit directory
    sudo rm -rf /usr/local/bin/lazygit

    sudo install lazygit /usr/local/bin

    # Clean up
    rm -rf lazygit.tar.gz lazygit

else
  echo "Lazygit is already up-to-date (version $current_lazygit_version)."
fi
