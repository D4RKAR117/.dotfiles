

# Exports and path augmentations
export VOLTA_HOME="$HOME/.volta"
#export VSCODE_HOME=$(find $HOME/.vscode-server -type f -name "code" -exec dirname {} \; | head -n 1)
export PATH=$HOME/bin:$VOLTA_HOME/bin:$HOME/.cargo/env:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export SUDO_EDITOR="nvim"
export EDITOR="nvim"
export BROWSER="wslview"
export DISPLAY=:0
export NODE_PATH=$(npm root --quiet -g)
export GPG_TTY=$(tty)
export EZA_CONFIG_DIR="$HOME/.config/eza"
export CAPACITOR_ANDROID_STUDIO_PATH=/snap/android-studio/current/bin/studio.sh
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA


source "$HOME/.private.sh"

## PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Skip global compinit
skip_global_compinit=1
