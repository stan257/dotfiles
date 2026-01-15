# Dotfiles

Configuration files for my development environment (macOS/Zsh).

## Contents

*   **zshrc**: Main Zsh configuration (plugins, aliases, prompt).
*   **ripgreprc**: Configuration for `ripgrep` (ignore patterns, defaults).

## Installation

Files are installed via symbolic links to the home directory.

```bash
# Backup existing files
mv ~/.zshrc ~/.zshrc.bak
mv ~/.ripgreprc ~/.ripgreprc.bak

# Create symlinks
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/ripgreprc ~/.ripgreprc
```
