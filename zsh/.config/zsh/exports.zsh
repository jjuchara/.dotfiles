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

export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.fnm:$PATH
export PATH="$HOME/.local/share/neovim/bin":$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
eval "$(zoxide init zsh)"



