# Shell History Configuration
export HISTSIZE=10000
export SAVEHIST=10000

# Detect shell to set correct history file
if [ -n "$ZSH_VERSION" ]; then
    HISTFILE="$HOME/.shell_history/zsh_history"
    setopt HIST_VERIFY
    setopt SHARE_HISTORY
    setopt APPEND_HISTORY
    setopt INC_APPEND_HISTORY
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
    setopt HIST_FIND_NO_DUPS
    setopt HIST_SAVE_NO_DUPS
elif [ -n "$BASH_VERSION" ]; then
    HISTFILE="$HOME/.shell_history/bash_history"
    export HISTCONTROL=ignoreboth:erasedups
    shopt -s histappend
fi

# Ensure directory exists (just in case)
mkdir -p "$(dirname "$HISTFILE")"
