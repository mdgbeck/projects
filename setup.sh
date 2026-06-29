#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}==>${NC} $1"; }

DOCS="$HOME/Documents"
DOTFILES="$DOCS/projects/dot_files"

# ── System update ──────────────────────────────────────────────────────────────
info "Updating system packages..."
sudo dnf upgrade -y

# ── Git config ─────────────────────────────────────────────────────────────────
info "Configuring git..."
git config --global user.name "Michael Groesbeck"
git config --global user.email "github.tech@704mail.com"

# ── SSH key ────────────────────────────────────────────────────────────────────
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    info "Generating SSH key..."
    ssh-keygen -t ed25519 -C "github.tech@704mail.com" -f "$HOME/.ssh/id_ed25519" -N ""
fi

info "Your public SSH key:"
echo ""
cat "$HOME/.ssh/id_ed25519.pub"
echo ""
warn "Add the above key to GitHub: https://github.com/settings/ssh/new"
read -rp "Press Enter once the key has been added to GitHub..."

info "Testing GitHub SSH connection..."
ssh -T git@github.com 2>&1 || true

# ── Clone repos ────────────────────────────────────────────────────────────────
info "Cloning repositories..."
mkdir -p "$DOCS"
[ ! -d "$DOCS/life" ]     && git clone git@github.com:mdgbeck/life.git "$DOCS/life"
[ ! -d "$DOCS/projects" ] && git clone git@github.com:mdgbeck/projects.git "$DOCS/projects"

# ── Symlink dotfiles ───────────────────────────────────────────────────────────
info "Symlinking dotfiles..."
ln -sf "$DOTFILES/.bashrc"       "$HOME/.bashrc"
ln -sf "$DOTFILES/.vimrc"        "$HOME/.vimrc"
ln -sf "$DOTFILES/tmux.conf"     "$HOME/.tmux.conf"
mkdir -p "$HOME/.config/alacritty"
ln -sf "$DOTFILES/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# ── DNF packages ───────────────────────────────────────────────────────────────
info "Installing packages..."
sudo dnf install -y vim tmux gh alacritty nodejs R

# ── RPM Fusion + Steam ────────────────────────────────────────────────────────
info "Enabling RPM Fusion and installing Steam..."
sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install -y steam

# ── vim-plug + plugins ────────────────────────────────────────────────────────
info "Installing vim-plug and plugins..."
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

# ── npm globals ────────────────────────────────────────────────────────────────
info "Installing global npm packages..."
sudo npm install -g @anthropic-ai/claude-code

# ── Flatpak ────────────────────────────────────────────────────────────────────
info "Installing Flatpak apps..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub com.bitwarden.desktop

# ── RStudio ────────────────────────────────────────────────────────────────────
info "Installing RStudio..."
RSTUDIO_VER=$(curl -sL https://download1.rstudio.org/current.ver)
RSTUDIO_RPM_VER=$(echo "$RSTUDIO_VER" | sed 's/+/-/' | sed 's/\.pro[0-9]*//')
sudo dnf install -y "https://download1.rstudio.org/electron/rhel9/x86_64/rstudio-${RSTUDIO_RPM_VER}-x86_64.rpm"

# ── uv ─────────────────────────────────────────────────────────────────────────
info "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# ── Caps/Esc swap ──────────────────────────────────────────────────────────────
info "Swapping Caps Lock and Escape..."
sudo localectl set-x11-keymap us pc105 "" "caps:swapescape"

# ── KDE: default terminal + shortcut fix ──────────────────────────────────────
info "Configuring KDE..."
kwriteconfig6 --file kdeglobals --group General --key TerminalApplication alacritty
kwriteconfig6 --file kdeglobals --group General --key TerminalService Alacritty.desktop
kwriteconfig6 --file kglobalshortcutsrc --group "KWin" --key "Edit Tiles" "none,Meta+T,Toggle Tiles Editor"

info "Done! Log out and back in for keyboard changes to take effect."
warn "GPU drivers and Steam tweaks must be set up manually per device."
