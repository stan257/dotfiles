#!/bin/bash

# ============================================================
# STACK BOOTSTRAPPER
# Installs Nvim, Tmux, and Zsh configs from GitHub.
# ============================================================

GITHUB_USER="stan257"
DOTFILES_DIR="$HOME/dotfiles"
TMUX_DIR="$HOME/tmux-config"
NVIM_DIR="$HOME/.config/nvim"

echo "Starting Environment Setup..."

# --- 1. CLONE REPOSITORIES ---

# Function to clone or pull if exists
clone_or_pull() {
    local repo_url=$1
    local dest_dir=$2
    
    if [ -d "$dest_dir" ]; then
        echo "   Updating $dest_dir..."
        git -C "$dest_dir" pull
    else
        echo "   Cloning $repo_url..."
        git clone "$repo_url" "$dest_dir"
    fi
}

echo "Fetching Configurations..."
clone_or_pull "https://github.com/$GITHUB_USER/dotfiles.git" "$DOTFILES_DIR"
clone_or_pull "https://github.com/$GITHUB_USER/tmux-config.git" "$TMUX_DIR"
# Nvim config needs to go exactly to ~/.config/nvim
clone_or_pull "https://github.com/$GITHUB_USER/nvim-config.git" "$NVIM_DIR"

# --- 2. CREATE SYMLINKS ---

echo "Linking Dotfiles..."

create_symlink() {
    local src=$1
    local dest=$2
    
    # Backup if file exists and is not a symlink
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "   Backing up existing $dest to $dest.bak"
        mv "$dest" "$dest.bak"
    fi
    
    # Create link
    ln -sf "$src" "$dest"
    echo "   Linked $dest -> $src"
}

# Zsh (Source files in repo are without dots)
create_symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# Ripgrep
create_symlink "$DOTFILES_DIR/ripgreprc" "$HOME/.ripgreprc"

# Tmux
create_symlink "$TMUX_DIR/.tmux.conf" "$HOME/.tmux.conf"

# --- 3. PACKAGES & PLUGINS ---

echo "Installing Packages & Plugins..."

PACKAGES="bat zoxide lazygit fzf starship fd visidata jq btop duckdb tmuxp"

install_macos() {
    echo "   Detected macOS. Using Homebrew..."
    if command -v brew > /dev/null; then
        brew install $PACKAGES
    else
        echo "   Error: Homebrew not found. Please install it first: https://brew.sh/"
    fi
}

install_linux() {
    echo "   Linux detected. Installing dependencies..."
    
    # 1. Update & Install Basic Tools
    if command -v apt-get > /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git curl unzip tar build-essential
    fi

    # 2. Install "Apt-Safe" Packages (Tmux, FZF, Ripgrep, Bat, FD, VisiData, jq, btop)
    # Note: Ubuntu calls bat 'batcat' and fd 'fdfind'
    if command -v apt-get > /dev/null; then
        sudo apt-get install -y tmux fzf ripgrep bat fd-find visidata jq btop
        
        # Fix Bat name collision
        if ! command -v bat > /dev/null && command -v batcat > /dev/null; then
            mkdir -p ~/.local/bin
            ln -sf /usr/bin/batcat ~/.local/bin/bat
            export PATH=$HOME/.local/bin:$PATH
        fi

        # Fix FD name collision
        if ! command -v fd > /dev/null && command -v fdfind > /dev/null; then
            mkdir -p ~/.local/bin
            ln -sf /usr/bin/fdfind ~/.local/bin/fd
            export PATH=$HOME/.local/bin:$PATH
        fi
    fi

    # 3. Install Modern Tools via Scripts (Distro Agnostic)
    
    # Starship
    if ! command -v starship > /dev/null; then
        echo "   Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Zoxide
    if ! command -v zoxide > /dev/null; then
        echo "   Installing Zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    # Lazygit (Binary Install)
    if ! command -v lazygit > /dev/null; then
        echo "   Installing Lazygit..."
        LG_VER=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VER}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    fi

    # DuckDB (Binary Install)
    if ! command -v duckdb > /dev/null; then
        echo "   Installing DuckDB..."
        DUCKDB_VER=$(curl -s "https://api.github.com/repos/duckdb/duckdb/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo duckdb.zip "https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip"
        unzip duckdb.zip
        sudo install duckdb /usr/local/bin
        rm duckdb duckdb.zip
    fi
}

# OS Detection
OS_TYPE="$(uname -s)"
case "$OS_TYPE" in
    Darwin) install_macos ;;
    Linux)  install_linux ;;
    *)      echo "   Unsupported OS: $OS_TYPE" ;;
esac

# Zsh Plugins
ZSH_PLUGINS_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGINS_DIR"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "   Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "   Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Tmux Plugin Manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "   Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "   Tmux Plugin Manager already installed."
fi

echo "Setup Complete! Restart your terminal."
