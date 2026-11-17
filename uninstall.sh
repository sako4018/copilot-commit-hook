#!/bin/sh
# Removes the hook and restores git's default behaviour.
DEST="$HOME/.config/git"

[ "$(git config --global --get core.hooksPath)" = "$DEST/hooks" ] && git config --global --unset core.hooksPath
[ "$(git config --global --get core.editor)" = "$DEST/auto-editor" ] && git config --global --unset core.editor
rm -f "$DEST/hooks/prepare-commit-msg" "$DEST/auto-editor"

echo "Премахнато. git commit пак отваря обикновения редактор."
