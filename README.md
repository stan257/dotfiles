# Dotfiles

Configuration files for my development environment (macOS/Zsh).

## Contents

*   **zshrc**: Main Zsh configuration (plugins, aliases, prompt).
*   **ripgreprc**: Configuration for `ripgrep` (ignore patterns, defaults).
*   **install.sh**: Bootstrapping script to set up Zsh, Nvim, and Tmux configurations.

## Installation

To clone and install all configurations (Zsh, Nvim, Tmux) on a new machine:

```bash
git clone https://github.com/stan257/dotfiles.git
cd dotfiles
./install.sh
```

### Manual Installation

If you prefer to link files manually:

```bash
# Backup existing files
mv ~/.zshrc ~/.zshrc.bak
mv ~/.ripgreprc ~/.ripgreprc.bak

# Create symlinks
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/ripgreprc ~/.ripgreprc
```