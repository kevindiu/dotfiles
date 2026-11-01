export ZSH="/usr/share/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

ZSH_THEME=""

plugins=(
    git
    golang
    docker
    docker-compose
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# History Behavior (Preferences)
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS

# Source global profiles (DOCKER_HOST, history, etc.)
if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh(N); do
    if [ -r "$i" ]; then
      . "$i"
    fi
  done
  unset i
fi

# Initialize Starship prompt
eval "$(starship init zsh)"

# Initialize Zoxide (smart cd)
eval "$(zoxide init zsh)"

# GitHub CLI completion (Cached for speed)
GH_COMPLETION="$HOME/.cache/gh-completion.zsh"
if (( $+commands[gh] )); then
    if [[ ! -f "$GH_COMPLETION" || "$GH_COMPLETION" -ot "$commands[gh]" ]]; then
        mkdir -p "${GH_COMPLETION:h}"
        gh completion -s zsh > "$GH_COMPLETION" 2>/dev/null
    fi
    source "$GH_COMPLETION"
fi

if [ -z "$SSH_AUTH_SOCK" ] && ! pgrep -u "$USER" ssh-agent >/dev/null 2>&1; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

export LANG=en_US.UTF-8
[ -t 0 ] && export GPG_TTY=$(tty 2>/dev/null)

export RPIV_LANES_HOTKEY=alt+l

export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$HOME/.local/bin:$PATH:$GOBIN
export GOTMPDIR=$HOME/.go-tmp

# Smart tmux wrapper: handles inside-tmux calls gracefully without nesting errors
unalias tmux 2>/dev/null
tmux() {
    if [ "$#" -eq 0 ] && [ -n "$TMUX" ]; then
        if [ -x /usr/local/bin/tmux-select.sh ]; then
            /usr/local/bin/tmux-select.sh
        else
            command tmux
        fi
    elif [ "$#" -ge 1 ] && [ "$1" = "new" -o "$1" = "new-session" ] && [ -n "$TMUX" ]; then
        shift
        local sname=""
        if [ "$#" -ge 2 ] && [ "$1" = "-s" ]; then
            sname="$2"
            shift 2
        elif [ "$#" -ge 1 ] && [[ "$1" != -* ]]; then
            sname="$1"
            shift
        fi
        if [ -n "$sname" ]; then
            command tmux new-session -d -s "$sname" "$@" && command tmux switch-client -t "$sname"
        else
            local created
            created=$(command tmux new-session -d -P -F "#{session_name}" "$@")
            command tmux switch-client -t "$created"
        fi
    else
        command tmux "$@"
    fi
}

alias ls='eza --group-directories-first'
alias ll='eza -alF --group-directories-first'
alias la='eza -a --group-directories-first'
alias l='eza -1'
alias lt='eza --tree --level=2 --group-directories-first'
alias lsi='eza --icons --group-directories-first'
alias lli='eza -alF --icons --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# bat as cat/pager replacement
alias cat='bat --paging=never'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

alias vi='nvim'
alias vim='nvim'

# Git aliases (supplements oh-my-zsh git plugin; gc overridden for GPG signing)
alias gc='git commit -S'
alias gl='git log --oneline'
alias gd='git diff'

alias ghpr='gh pr create'
alias ghpv='gh pr view'
alias ghpl='gh pr list'

alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias kgy='kubectl get -o yaml'
alias kdp='kubectl describe pod'
alias kdl='kubectl delete'
alias kl='kubectl logs'
alias ke='kubectl edit'

alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'

mkcd() {
    mkdir -p "$@" && cd "$_";
}

(( $+commands[code] )) && [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

if [[ "$TERM_PROGRAM" != "vscode" ]] && [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -t 0 ]] && [[ ! -f "$HOME/.no_auto_tmux" ]] && [[ "${NO_AUTO_TMUX:-0}" != "1" ]]; then
    if [ -x /usr/local/bin/tmux-select.sh ]; then
        exec /usr/local/bin/tmux-select.sh
    else
        echo "🚀 Attaching to or starting tmux session 'main'..."
        exec tmux new-session -A -s main
    fi
fi
