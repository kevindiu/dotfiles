# Development environment optimizations
# These settings enhance the development experience


# Default editors and pagers
export EDITOR=nvim
export PAGER=less
export LESSHISTFILE=-

# Node.js optimizations for better performance
export NODE_OPTIONS="--max-old-space-size=4096"
export NPM_CONFIG_PROGRESS=false
export NPM_CONFIG_AUDIT=false
export NPM_CONFIG_FUND=false

# Rust optimizations
export CARGO_TARGET_DIR=/tmp/cargo-target
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Development tools optimization
# export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Timezone for consistent development
export TZ=${TZ:-UTC}