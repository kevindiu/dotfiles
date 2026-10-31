#!/bin/bash

set -euo pipefail

# If not running in an interactive terminal, fall back to plain shell
if [ ! -t 0 ] || [ ! -t 1 ]; then
    exec /bin/zsh "$@"
fi

in_active_tmux() {
    [ -n "${TMUX:-}" ] && tmux display-message -p "#{client_name}" >/dev/null 2>&1
}

if ! in_active_tmux; then
    unset TMUX
fi

attach_to_session() {
    local target="$1"
    if in_active_tmux; then
        echo "🔄 Switching to session '$target'..."
        tmux switch-client -t "$target"
    else
        unset TMUX
        echo "🚀 Attaching to session '$target'..."
        exec tmux attach-session -t "$target"
    fi
}

create_session() {
    local name="${1:-}"
    if in_active_tmux; then
        if [ -n "$name" ]; then
            echo "🚀 Creating and switching to session '$name'..."
            tmux new-session -d -s "$name"
            tmux switch-client -t "$name"
        else
            local created
            created=$(tmux new-session -d -P -F "#{session_name}")
            echo "🚀 Creating and switching to session '$created'..."
            tmux switch-client -t "$created"
        fi
    else
        unset TMUX
        if [ -n "$name" ]; then
            echo "🚀 Starting new tmux session '$name'..."
            exec tmux new-session -s "$name"
        else
            echo "🚀 Starting new tmux session..."
            exec tmux new-session
        fi
    fi
}

# If a specific session is explicitly requested, attach/create directly
if [ -n "${SESSION:-}" ]; then
    if in_active_tmux; then
        if ! tmux has-session -t "$SESSION" 2>/dev/null; then
            tmux new-session -d -s "$SESSION"
        fi
        exec tmux switch-client -t "$SESSION"
    else
        unset TMUX
        exec tmux new-session -A -s "$SESSION"
    fi
fi

# If explicit NEW=1 is passed, create a fresh unnamed session directly
if [ "${NEW:-0}" = "1" ]; then
    create_session ""
    exit 0
fi

# Check for existing tmux sessions
session_names=()
while IFS= read -r line; do
    [ -n "$line" ] && session_names+=("$line")
done < <(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)

# If no sessions exist, automatically start 'main'
if [ "${#session_names[@]}" -eq 0 ]; then
    create_session "main"
    exit 0
fi

# Gather session details for display
session_details=()
while IFS= read -r line; do
    [ -n "$line" ] && session_details+=("$line")
done < <(tmux list-sessions -F "#{session_name} (#{session_windows} window(s), attached: #{session_attached})" 2>/dev/null || true)

echo ""
echo "🖥️  Active Tmux Sessions:"
echo "--------------------------------------------------"
for i in "${!session_details[@]}"; do
    printf "  \033[0;34m[%d]\033[0m %s\n" "$((i + 1))" "${session_details[$i]}"
done
echo ""
echo "Actions:"
printf "  \033[0;32m[n]\033[0m Create a new session\n"
printf "  \033[0;33m[s]\033[0m Plain shell (no tmux)\n"
echo "--------------------------------------------------"

while true; do
    read -r -p "Select option [1-${#session_names[@]}, n, s] (default: 1): " choice
    choice="${choice:-1}"

    case "$choice" in
        [nN])
            read -r -p "Session name (leave blank for auto): " new_name
            create_session "$new_name"
            exit 0
            ;;
        [sS])
            echo "🐚 Opening plain zsh..."
            exec env NO_AUTO_TMUX=1 /bin/zsh
            ;;
        *)
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#session_names[@]}" ]; then
                selected="${session_names[$((choice - 1))]}"
                attach_to_session "$selected"
                exit 0
            else
                echo "⚠️  Invalid selection. Please choose 1-${#session_names[@]}, 'n', or 's'."
            fi
            ;;
    esac
done
