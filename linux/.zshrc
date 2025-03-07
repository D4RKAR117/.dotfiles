# Set the directory to store zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"
source "$HOME/.zinit.utils.zsh"

# Plugin Flags
ZOXIDE_CMD_OVERRIDE="cd"
zstyle ':omz:plugins:eza' 'icons' yes
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTONAME_SESSION=true
setopt globdots

# Prompt configuration
eval "$(oh-my-posh init zsh --config $HOME/.config/omp/config.toml)"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# OMZ Libraries
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::misc.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::termsupport.zsh
zinit snippet OMZL::grep.zsh

# OMZ Snippets/Plugins
zinit snippet OMZP::git
zinit snippet OMZP::ssh
zinit snippet OMZP::common-aliases
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colorize
zinit snippet OMZP::history 
zinit snippet OMZP::zoxide
zinit snippet OMZP::fzf
zinit snippet OMZP::volta
zinit snippet OMZP::rust
zinit ice as"completion"
zinit snippet OMZP::rust/_rustc
zinit snippet OMZP::npm
zinit snippet OMZP::node
zinit snippet OMZP::eza
zinit ice as"completion"
zinit snippet https://github.com/eza-community/eza/blob/main/completions/zsh/_eza
zinit ice atpull"%atclone" atclone"_fix-omz-plugin"
zinit snippet OMZP::tmux


# Install completions from Plugins
zinit fpath -f "$ZSH_CACHE_DIR/completions"

# Load zsh-completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Plugins that depend on completions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions

# Keybindings
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History config
HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias bat="batcat"


# Zsh styling
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' filename-completion
zstyle ':completion:*' keep-completion-history true 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -DA --icons=auto --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -DA --icons=auto --color=always $realpath'
zstyle ':fzf-tab:complete:cp:*' fzf-preview 'if [ -d $realpath ]; then eza -DA --icons=auto --color=always $realpath; else batcat --color=always --style=numbers --line-range=:500 $realpath; fi'
zstyle ':fzf-tab:complete:mv:*' fzf-preview 'if [ -d $realpath ]; then eza -DA --icons=auto --color=always $realpath; else batcat --color=always --style=numbers --line-range=:500 $realpath; fi'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -DA --icons=auto --color=always $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'if [ -d $realpath ]; then eza -DA --icons=auto --color=always $realpath; else batcat --color=always --style=numbers --line-range=:500 $realpath; fi'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'if [ -d $realpath ]; then eza -DA --icons=auto --color=always $realpath; else batcat --color=always --style=numbers --line-range=:500 $realpath; fi'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'



# Shell integrations

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

alias podman='podman-remote'
