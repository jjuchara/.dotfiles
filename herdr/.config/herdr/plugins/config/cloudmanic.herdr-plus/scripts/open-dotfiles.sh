#!/bin/zsh

set -eu

dotfiles_root=${DOTFILES_DIR:-"$HOME/.dotfiles"}

if [[ ! -d "$dotfiles_root" ]]; then
  print -u2 "Dotfiles directory does not exist: $dotfiles_root"
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  print -u2 "fzf is required to select a dotfiles package"
  exit 1
fi

export DOTFILES_ROOT="$dotfiles_root"

selection=$(
  find "$dotfiles_root" -mindepth 1 -maxdepth 1 -type d ! -name .git -exec basename {} \; |
    sort |
    fzf \
      --prompt='Dotfiles > ' \
      --header='Выберите конфигурацию для открытия' \
      --height=100% \
      --layout=reverse \
      --border \
      --preview='find "$DOTFILES_ROOT/{}" -mindepth 1 -maxdepth 3 -print | head -80' \
      --preview-window='right,55%,border-left'
) || exit 0

[[ -n "$selection" ]] || exit 0

package_dir="$dotfiles_root/$selection"
editor_args=(.)

case "$selection" in
  git)
    target_dir="$package_dir"
    editor_args=(.gitconfig .gitignore_global)
    ;;
  lazyVim)
    target_dir="$package_dir/.config/LazyVim"
    editor_args=(. .gitignore .neoconf.json ../../.claude/settings.local.json)
    ;;
  mcpHub)
    target_dir="$package_dir/.config/mcphub"
    ;;
  starship)
    target_dir="$package_dir/.config"
    editor_args=(starship.toml)
    ;;
  zsh)
    target_dir="$package_dir/.config/zsh"
    editor_args=(. ../../.zshrc)
    ;;
  *)
    target_dir="$package_dir/.config/$selection"
    ;;
esac

if [[ ! -d "$target_dir" ]]; then
  print -u2 "Configuration directory does not exist: $target_dir"
  exit 1
fi

cd "$target_dir"

# Load the interactive zsh configuration so the `n` alias selects LazyVim.
exec /bin/zsh -ic 'n "$@"' dotfiles-editor "${editor_args[@]}"
