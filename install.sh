#!/bin/sh
# Installs the auto commit message hook (global, for all repos).
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.config/git"

# Do not silently replace the user's own git settings.
check() {
  cur=$(git config --global --get "$1" || true)
  if [ -n "$cur" ] && [ "$cur" != "$2" ]; then
    echo "Вече имаш зададено $1 = $cur"
    echo "Не го презаписвам. Махни го ръчно (git config --global --unset $1) и пусни пак."
    exit 1
  fi
}
check core.hooksPath "$DEST/hooks"
check core.editor "$DEST/auto-editor"

mkdir -p "$DEST/hooks"

# copy SRC (relative to the repo) to TARGET, keeping a backup of a different old file
install_file() {
  src="$DIR/$1"
  target="$2"
  if [ -f "$target" ] && ! cmp -s "$src" "$target"; then
    cp "$target" "$target.bak"
    echo "Старият $target е запазен като $target.bak"
  fi
  cp "$src" "$target"
  chmod +x "$target"
}
install_file hooks/prepare-commit-msg "$DEST/hooks/prepare-commit-msg"
install_file hooks/auto-editor "$DEST/auto-editor"

git config --global core.hooksPath "$DEST/hooks"
git config --global core.editor "$DEST/auto-editor"

echo "Готово."
if ! command -v copilot >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/copilot" ]; then
  echo "ВНИМАНИЕ: Copilot CLI не е намерен. Инсталирай го: npm install -g @github/copilot"
  echo "и влез с: copilot login"
fi
