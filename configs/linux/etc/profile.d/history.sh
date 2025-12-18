# Shell History Configuration
export HISTSIZE=10000
export SAVEHIST=10000

# Detect shell to set correct history file
if [ -n "$ZSH_VERSION" ]; then
    HISTFILE="$HOME/.shell_history/zsh_history"
elif [ -n "$BASH_VERSION" ]; then
    HISTFILE="$HOME/.shell_history/bash_history"
    export HISTCONTROL=ignoreboth:erasedups
    shopt -s histappend
fi

# Ensure directory exists (just in case)
mkdir -p "$(dirname "$HISTFILE")"
