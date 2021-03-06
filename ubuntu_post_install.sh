sudo apt install xclip curl git ssh
ssh-keygen -t ed25519 -C 'mdgbeck@gmail.com'
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
xclip -selection clipboard < ~/.ssh/id_ed25519.pub 
# go to github and add
cd ~/Documents/
git clone git@github.com:mdgbeck/projects.git
cd
sudo apt install gnome-tweaks
sudo apt install vim-gtk3
rm ~/.bashrc
rm ~/.vimrc
ln -s ~/Documents/projects/dot_files/.vimrc ~/.vimrc
ln -s ~/Documents/projects/dot_files/.bashrc ~/.bashrc
ln -s ~/Documents/projects/dot_files/.Rprofile ~/.Rprofile
curl -fLo ~/.vim/autoload/plug.vim --create-dirs     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
base16_gruvbox-dark-pale 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt update
sudo apt install r-base
sudo apt update
sudo apt install r-base
ln -s ~/Documents/projects/dot_files/.Rprofile ~/.Rprofile
ls
vim ~/.ssh/config
sudo apt install python3-pip
pip3 install pipenv
sudo pip3 install ipython
sudo apt install libssl-dev libcurl4-openssl-dev libxml2-dev
