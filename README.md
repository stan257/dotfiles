# Dotfiles

A cross-platform (macOS/Linux) bootstrap for a modern development environment.

## Features

*   **Zsh**: Optimized config with Starship prompt, zsh-autosuggestions, and syntax highlighting.
*   **Neovim**: Automatic setup of custom Nvim configurations.
*   **Tmux**: Configured with Tmux Plugin Manager (TPM).
*   **Modern CLI Tools**: Automated installation for `bat`, `zoxide`, `lazygit`, `fzf`, `fd`, `visidata`, and `ripgrep`.
*   **OS Agnostic**: Hardened `install.sh` for macOS (Homebrew) and Linux (apt, binary, or script installs).

## Quick Start

Run the bootstrapper to set up the environment:

```bash
git clone https://github.com/stan257/dotfiles.git
cd dotfiles
./install.sh
```

## Structure

*   `zshrc`: Main Zsh configuration and aliases.
*   `ripgreprc`: Default `ripgrep` search patterns and options.
*   `install.sh`: Environment-aware installation and symlinking script.

## Manual Setup

To manually link core configuration files:

```bash
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/ripgreprc ~/.ripgreprc
```
