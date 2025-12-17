export ZSH="/usr/share/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

ZSH_THEME=""

plugins=(
    git
    golang
    tmux
    docker
    docker-compose
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Initialize Starship prompt
eval "$(starship init zsh)"

# Initialize Zoxide (smart cd)
eval "$(zoxide init zsh)"

# GitHub CLI completion
# GitHub CLI completion (Cached for speed)
GH_COMPLETION="$HOME/.cache/gh-completion.zsh"
if command -v gh &> /dev/null; then
    if [ ! -f "$GH_COMPLETION" ] || [ $(date +%s -r "$GH_COMPLETION") -lt $(date +%s -r $(which gh)) ]; then
        mkdir -p "$(dirname "$GH_COMPLETION")"
        gh completion -s zsh > "$GH_COMPLETION" 2>/dev/null
    fi
    source "$GH_COMPLETION"
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

export LANG=en_US.UTF-8

export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN
export GOTMPDIR=$HOME/.go-tmp

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias vi='nvim'
alias vim='nvim'

alias gs='git status'
alias ga='git add'
alias gc='git commit -S'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'

alias ghpr='gh pr create'
alias ghpv='gh pr view'
alias ghpl='gh pr list'

alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'

mkcd() {
    mkdir -p "$@" && cd "$_";
}

if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -t 0 ]] && [[ ! -f "$HOME/.no_auto_tmux" ]]; then 
    echo "🚀 Starting new tmux session"
    exec tmux new-session
fi

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
