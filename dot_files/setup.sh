#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Symlinking dotfiles..."
ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/.Rprofile" "$HOME/.Rprofile"

echo "==> Loading GNOME settings..."
dconf load / < "$DOTFILES_DIR/dconf-settings.ini"

echo "==> Installing packages..."
sudo dnf install -y \
    gh \
    R \
    vim

echo "==> Done. Run 'source ~/.bashrc' to apply shell config."
