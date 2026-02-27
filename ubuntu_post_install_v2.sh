#!/bin/bash
set -eo pipefail

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
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.bak
[ -f ~/.vimrc ]  && cp ~/.vimrc ~/.vimrc.bak
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


# ─── R ───────────────────────────────────────────────────────────────────────
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xE298A3A825C0D65DFD57CBB651716619E084DAB9" \
    | sudo gpg --dearmor -o /usr/share/keyrings/cran-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/cran-archive-keyring.gpg] https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    | sudo tee /etc/apt/sources.list.d/cran.list
sudo apt update
sudo apt install -y r-base

# R package build dependencies
sudo apt install -y libssl-dev libcurl4-openssl-dev libxml2-dev

ln -s ~/Documents/projects/dot_files/.Rprofile ~/.Rprofile

# ─── Python ──────────────────────────────────────────────────────────────────
sudo apt install -y python3-pip
pip3 install --user pipenv
pip3 install --user ipython

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
sudo ubuntu-drivers autoinstall
sudo apt install -y opencl-headers

echo ""
echo "Setup complete."
