#!/bin/sh
# HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000
SAVEHIST=1000000
export EDITOR="nviml"
export TERMINAL="ghostty"
export BROWSER="arc "
export PATH="$HOME/.local/bin":$PATH
export MANPAGER='nviml +Man!'
export MANWIDTH=999

# Keep the GitHub MCP token out of the tracked dotfiles.
if command -v security >/dev/null 2>&1; then
  CODEX_GITHUB_PERSONAL_ACCESS_TOKEN="$(security find-generic-password -a "$USER" -s codex-github-mcp -w 2>/dev/null)"
  if [ -n "$CODEX_GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
    export CODEX_GITHUB_PERSONAL_ACCESS_TOKEN
  else
    unset CODEX_GITHUB_PERSONAL_ACCESS_TOKEN
  fi
fi

export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.fnm:$PATH
export PATH="$HOME/.local/share/neovim/bin":$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
eval "$(zoxide init zsh)"


