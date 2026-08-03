#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# apps -> ~/.config/<app>
CONFIG_APPS=(alacritty nvim sway waybar wofi)

# shell files -> $HOME/<name>
SHELL_FILES=('.zshenv' '.zshrc')

# git files -> $HOME/<name>
GIT_FILES=('.gitconfig' '.gitignore')

link() {
    local target="$1"
    local src="$2"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "SKIP  $target (exists and is not a symlink)"
        return
    fi
    ln -sfn "$src" "$target"
    echo "LINK  $target -> $src"
}

echo "==> XDG config apps"
for app in "${CONFIG_APPS[@]}"; do
    link "$HOME/.config/$app" "$DOTFILES/$app"
done

echo "==> Shell"
for f in "${SHELL_FILES[@]}"; do
    link "$HOME/$f" "$DOTFILES/shell/$f"
done

echo "==> Git"
for f in "${GIT_FILES[@]}"; do
    link "$HOME/$f" "$DOTFILES/git/$f"
done

echo "Done."