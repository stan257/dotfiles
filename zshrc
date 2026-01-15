
# ==============================================================================
# CORE SYSTEM SETTINGS
# ==============================================================================
# Terminal Title
echo -n -e "\033]0;Mac Terminal\007"

# PATH Configuration (Prioritize Homebrew ARM & User Python)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/Library/Python/3.13/bin:$PATH"

# Editor Defaults
export EDITOR="nvim"
export VISUAL="nvim"
export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacad

# ==============================================================================
# ZSH CONFIGURATION (History & Completion)
# ==============================================================================
# History: Share history across terminals, ignore dupes, huge file
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Completions (Lazy load for speed)
fpath=("${(@)fpath:#/usr/local/share/zsh/site-functions}") # Remove old Intel brew
fpath+=("/opt/homebrew/share/zsh/site-functions")
autoload -Uz compinit
# Only run compinit check once a day (massively speeds up shell start)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi

# ==============================================================================
# PLUGINS & PROMPT
# ==============================================================================
# 1. Starship Prompt (Try to load, fallback to manual if missing)
if command -v starship > /dev/null; then
    eval "$(starship init zsh)"
else
    # Fallback to manual prompt if Starship isn't installed
    setopt PROMPT_SUBST
    PROMPT='%F{white}%B[%b %f%K{white}%F{black}%D{%I:%M:%S}%f%k %F{white}%m %U%F{027}%~%f%u%F{white} %B] %b$%f '
fi

# 2. Syntax Highlighting & Autosuggestions (Cloned to ~/.zsh)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 3. Zoxide (Smart Directory Navigation)
if command -v zoxide > /dev/null; then
    eval "$(zoxide init zsh)"
fi

# 4. FZF (Fuzzy Finder)
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF + Bat Integration (Preview + Scroll)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
--preview 'bat --style=numbers --color=always --line-range :500 {}' \
--bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up'"

# ==============================================================================
# ALIASES & FUNCTIONS
# ==============================================================================
# System
alias c="clear"
alias copy="cp"
alias ll="ls -lah"
alias lh="ls -a | egrep '^\.'"
alias grep="grep --color"
alias f='find . | grep'

# Vim/Config
alias vim="nvim"
alias vz="nvim ~/.zshrc"
alias sz="source ~/.zshrc; echo '~/.zshrc sourced'"

# Git UI
alias lg="lazygit"

# Networking
alias ip="ifconfig -a | egrep -A 7 '^en0' | grep inet | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | head -n 1"
alias myip="curl -s http://checkip.dyndns.org/ | sed 's/[a-zA-Z<>/ :]//g'"

# Fun
cow() { cowsay "$1"; echo; }
quote() { echo; fortune; echo; }

# Bat (Cat replacement)
if command -v bat > /dev/null; then
    alias cat='bat'
fi

# ==============================================================================
# RIPGREP CONFIGURATION
# ==============================================================================
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Ripgrep Shortcuts
alias rgy='rg -t py'                # Search Python files
alias rgf='rg --files | rg'         # Fuzzy file finder
alias rgdef='rg -t py "^def\s+"'    # Find python function definitions

# ==============================================================================
# PYTHON ENVIRONMENTS (Conda/Mamba)
# ==============================================================================
# Managed by conda init
__conda_setup="$($HOME/miniforge3/bin/conda shell.zsh hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

# Managed by mamba shell init
export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
__mamba_setup="$( $MAMBA_EXE shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    unalias mamba 2> /dev/null
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup

