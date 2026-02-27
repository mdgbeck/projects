#!/bin/bash
set -e

# ─── SSH Setup ───────────────────────────────────────────────────────────────
sudo apt install -y xclip curl git ssh

ssh-keygen -t ed25519 -C 'mdgbeck@gmail.com'
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard and open GitHub SSH settings in browser
xclip -selection clipboard < ~/.ssh/id_ed25519.pub
echo "Your SSH public key has been copied to the clipboard."
xdg-open https://github.com/settings/ssh/new 2>/dev/null || true
read -rp "Press Enter once you have added the SSH key to GitHub..."

# ─── Clone dotfiles repo ──────────────────────────────────────────────────────
mkdir -p ~/Documents
cd ~/Documents
git clone git@github.com:mdgbeck/projects.git
cd ~

# ─── Desktop / Editor packages ───────────────────────────────────────────────
sudo apt install -y gnome-tweaks vim-gtk3

# ─── Dotfile symlinks ─────────────────────────────────────────────────────────
rm -f ~/.bashrc ~/.vimrc
ln -s ~/Documents/projects/dot_files/.vimrc ~/.vimrc
ln -s ~/Documents/projects/dot_files/.bashrc ~/.bashrc

# Source bashrc instead of requiring a terminal restart
# shellcheck disable=SC1090
source ~/.bashrc

# ─── Vim plugin manager + plugins ────────────────────────────────────────────
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins non-interactively
vim +PlugInstall +qall

# ─── Terminal color scheme ───────────────────────────────────────────────────
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# Source base16-shell so the theme command is available without a terminal restart
# shellcheck disable=SC1090
source ~/.config/base16-shell/profile_helper.sh
base16_gruvbox-dark-pale

# ─── R ───────────────────────────────────────────────────────────────────────
sudo apt-key adv --keyserver keyserver.ubuntu.com \
    --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# Use lsb_release so this works on non-focal Ubuntu releases too
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt update
sudo apt install -y r-base

# R package build dependencies
sudo apt install -y libssl-dev libcurl4-openssl-dev libxml2-dev

ln -s ~/Documents/projects/dot_files/.Rprofile ~/.Rprofile

# ─── Python ──────────────────────────────────────────────────────────────────
sudo apt install -y python3-pip
pip3 install pipenv
sudo pip3 install ipython

# ─── SSH config ──────────────────────────────────────────────────────────────
# Open SSH config for editing if it doesn't already exist / needs setup
if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
fi
vim ~/.ssh/config

# ─── USB WiFi driver (rtl8812au) ─────────────────────────────────────────────
git clone https://github.com/aircrack-ng/rtl8812au.git ~/rtl8812au
cd ~/rtl8812au
sudo make install
cd ~

# ─── OpenCL / NVIDIA (headless) ──────────────────────────────────────────────
# Check https://ubuntu.com/server/docs/nvidia-drivers-installation for the
# latest recommended driver version before running this section.
sudo apt install -y nvidia-headless-510 opencl-headers

echo ""
echo "Setup complete."
