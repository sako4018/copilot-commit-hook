#!/bin/sh
# Installs the auto commit message hook (global, for all repos).
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.config/git"

# Do not silently replace the user's own git settings.
check() {
  cur=$(git config --global --get "$1" || true)
  if [ -n "$cur" ] && [ "$cur" != "$2" ]; then
    echo "You already have $1 = $cur"
    echo "Not overwriting it. Remove it first (git config --global --unset $1) and run this again."
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
    echo "Old $target saved as $target.bak"
  fi
  cp "$src" "$target"
  chmod +x "$target"
}
install_file hooks/prepare-commit-msg "$DEST/hooks/prepare-commit-msg"
install_file hooks/auto-editor "$DEST/auto-editor"

git config --global core.hooksPath "$DEST/hooks"
git config --global core.editor "$DEST/auto-editor"

echo "Done."
if ! command -v copilot >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/copilot" ]; then
  echo "WARNING: Copilot CLI not found. Install it: npm install -g @github/copilot"
  echo "and sign in with: copilot login"
fi
