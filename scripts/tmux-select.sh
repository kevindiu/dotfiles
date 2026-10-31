#!/bin/bash

set -euo pipefail

# If not running in an interactive terminal, fall back to plain shell
if [ ! -t 0 ] || [ ! -t 1 ]; then
    exec /bin/zsh "$@"
fi

# If a specific session is explicitly requested, attach/create directly
if [ -n "${SESSION:-}" ]; then
    exec tmux new-session -A -s "$SESSION"
fi

# If explicit NEW=1 is passed, create a fresh unnamed session directly
if [ "${NEW:-0}" = "1" ]; then
    exec tmux new-session
fi

# Check for existing tmux sessions
session_names=()
while IFS= read -r line; do
    [ -n "$line" ] && session_names+=("$line")
done < <(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)

# If no sessions exist, automatically start 'main'
if [ "${#session_names[@]}" -eq 0 ]; then
    echo "🚀 Starting new tmux session 'main'..."
    exec tmux new-session -s main
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
            if [ -n "$new_name" ]; then
                exec tmux new-session -s "$new_name"
            else
                exec tmux new-session
            fi
            ;;
        [sS])
            echo "🐚 Opening plain zsh..."
            exec /bin/zsh
            ;;
        *)
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#session_names[@]}" ]; then
                selected="${session_names[$((choice - 1))]}"
                echo "🚀 Attaching to session '$selected'..."
                exec tmux attach-session -t "$selected"
            else
                echo "⚠️  Invalid selection. Please choose 1-${#session_names[@]}, 'n', or 's'."
            fi
            ;;
    esac
done
