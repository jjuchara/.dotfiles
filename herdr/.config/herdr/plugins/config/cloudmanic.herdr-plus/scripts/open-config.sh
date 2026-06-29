#!/bin/sh

set -eu

config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
plugin_config_dir=${HERDR_PLUGIN_CONFIG_DIR:-"$config_home/herdr/plugins/config/cloudmanic.herdr-plus"}

case ${1:-} in
  herdr)
    target=${HERDR_CONFIG_PATH:-"$config_home/herdr/config.toml"}
    ;;
  workspace)
    target="$plugin_config_dir/projects"
    ;;
  worktree)
    target="$plugin_config_dir/worktrees"
    ;;
  actions)
    target="$plugin_config_dir/quick-actions"
    ;;
  *)
    printf 'Usage: %s {herdr|workspace|worktree|actions}\n' "$0" >&2
    exit 2
    ;;
esac

if [ -d "$target" ]; then
  :
elif [ "$target" = "${HERDR_CONFIG_PATH:-"$config_home/herdr/config.toml"}" ]; then
  if [ ! -f "$target" ]; then
    printf 'Herdr config does not exist: %s\n' "$target" >&2
    exit 1
  fi
else
  mkdir -p "$target"
fi

# Run an interactive zsh so aliases from ~/.zshrc are available. The extra
# argument becomes $0; the selected config path is passed safely as $1.
exec /bin/zsh -ic 'n "$1"' herdr-config "$target"
