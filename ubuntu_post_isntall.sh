!/bin/bash

# Update
sudo apt update; sudo apt upgrade -y

# remove tiny vim
sudo apt remove --assume-yes vim-tiny

# install packages
sudo apt install git xclip curl vim


# install vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install darktable
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/graphics:darktable.list"
wget -nv https://download.opensuse.org/repositories/graphics:darktable/xUbuntu_18.04/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt update
sudo apt install darktable


