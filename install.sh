#!/bin/bash

# Simple script to install Bash configuration files in the home directory. Uses
# symlinks instead of copying the files. Creates a backup of the existing
# configuration by appending '.bak'.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo 'Linking .bashrc'
mv ~/.bashrc ~/.bashrc.bak
ln -s $DIR/bashrc ~/.bashrc

echo 'Linking .bash_aliases'
mv ~/.bash_aliases ~/.bash_aliases.bak
ln -s $DIR/bash_aliases ~/.bash_aliases

echo 'Linking .profile'
mv ~/.profile ~/.profile.bak
ln -s $DIR/profile ~/.profile

echo 'Installing git helpers'
mv ~/.git-prompt.sh ~/.git-prompt.sh.bak
wget -O ~/.git-prompt.sh https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
chmod +x ~/.git-prompt.sh
mv ~/.git-completion.sh ~/.git-completion.sh.bak
wget -O ~/.git-completion.sh https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
chmod +x ~/.git-completion.sh
