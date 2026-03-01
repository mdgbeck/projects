#!/bin/bash
set -eo pipefail

echo "============================================"
echo " Ubuntu Post-Install Setup"
echo "============================================"
echo ""

# ─── Update package lists ────────────────────────────────────────────────────
echo ">>> Updating package lists..."
sudo apt update
echo "Package lists updated."

# ─── Base packages ───────────────────────────────────────────────────────────
echo ""
echo ">>> [1/9] Installing base packages (git, curl, xclip)..."
sudo apt install -y xclip curl git ssh
echo "Base packages installed."

# ─── SSH Setup ───────────────────────────────────────────────────────────────
echo ""
echo ">>> [2/9] Generating SSH key..."
ssh-keygen -t ed25519 -C 'mdgbeck@gmail.com'
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

xclip -selection clipboard < ~/.ssh/id_ed25519.pub
echo "SSH public key copied to clipboard."
xdg-open https://github.com/settings/ssh/new 2>/dev/null || true
read -rp "Press Enter once you have added the SSH key to GitHub..."

# ─── Clone dotfiles repo ──────────────────────────────────────────────────────
echo ""
echo ">>> [3/9] Cloning dotfiles repo..."
mkdir -p ~/Documents
cd ~/Documents
git clone git@github.com:mdgbeck/projects.git
cd ~
echo "Dotfiles repo cloned to ~/Documents/projects."

# ─── Desktop / Editor packages ───────────────────────────────────────────────
echo ""
echo ">>> [4/9] Installing desktop and editor packages..."
sudo apt install -y gnome-tweaks vim-gtk3
echo "Desktop and editor packages installed."

# ─── Dotfile symlinks ─────────────────────────────────────────────────────────
echo ""
echo ">>> [5/9] Setting up dotfile symlinks..."
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.bak && echo "Backed up existing .bashrc to .bashrc.bak"
[ -f ~/.vimrc ]  && cp ~/.vimrc ~/.vimrc.bak   && echo "Backed up existing .vimrc to .vimrc.bak"
rm -f ~/.bashrc ~/.vimrc
ln -s ~/Documents/projects/dot_files/.vimrc ~/.vimrc
ln -s ~/Documents/projects/dot_files/.bashrc ~/.bashrc
echo "Symlinks created."

# Source bashrc instead of requiring a terminal restart
# shellcheck disable=SC1090
source ~/.bashrc

# ─── Vim plugin manager + plugins ────────────────────────────────────────────
echo ""
echo ">>> [6/9] Installing Vim plugin manager and plugins..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Running :PlugInstall — this may take a moment..."
vim +PlugInstall +qall
echo "Vim plugins installed."

# ─── R ───────────────────────────────────────────────────────────────────────
echo ""
echo ">>> [7/9] Setting up R..."
echo "Adding CRAN apt repository..."
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xE298A3A825C0D65DFD57CBB651716619E084DAB9" \
    | sudo gpg --dearmor -o /usr/share/keyrings/cran-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/cran-archive-keyring.gpg] https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
    | sudo tee /etc/apt/sources.list.d/cran.list
sudo apt update
echo "Installing r-base and R package build dependencies..."
sudo apt install -y r-base libssl-dev libcurl4-openssl-dev libxml2-dev
ln -s ~/Documents/projects/dot_files/.Rprofile ~/.Rprofile
echo "R installed."

# ─── Python ──────────────────────────────────────────────────────────────────
echo ""
echo ">>> [8/9] Setting up Python packages..."
sudo apt install -y python3-pip
pip3 install --user pipenv
pip3 install --user ipython
echo "Python packages installed."

# ─── SSH config ──────────────────────────────────────────────────────────────
echo ""
echo ">>> Opening SSH config for editing. Save and quit when done (:wq)..."
if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
fi
vim ~/.ssh/config

# ─── USB WiFi driver (rtl8812au) ─────────────────────────────────────────────
echo ""
echo ">>> [9/9] Building and installing USB WiFi driver (rtl8812au)..."
echo "Installing build dependencies..."
sudo apt install -y build-essential "linux-headers-$(uname -r)"
git clone https://github.com/aircrack-ng/rtl8812au.git ~/rtl8812au
cd ~/rtl8812au
echo "Compiling driver — this may take a few minutes..."
sudo make install
cd ~
echo "WiFi driver installed."

# ─── OpenCL / NVIDIA ─────────────────────────────────────────────────────────
echo ""
echo ">>> Installing NVIDIA drivers (auto-detecting recommended driver)..."
sudo ubuntu-drivers autoinstall
sudo apt install -y opencl-headers
echo "NVIDIA drivers installed."

echo ""
echo "============================================"
echo " Setup complete!"
echo " Reboot recommended to load new drivers."
echo "============================================"
