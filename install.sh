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

echo 'Linking .bash_profile'
mv ~/.bash_profile ~/.bash_profile.bak
ln -s $DIR/bash_profile ~/.bash_profile

echo 'Linking .bash_completion'
mv "$HOME/.bash_completion" "$HOME/.bash_completion.bak"
ln -s "$DIR/bash_completion" "$HOME/.bash_completion"

echo 'Linking .bash_private'
if [ -f $DIR/bash_private ]; then
    mv ~/.bash_private ~/.bash_private.bak
    ln -s $DIR/bash_private ~/.bash_private
fi

echo 'Linking .xsessionrc'
if [ -f $DIR/xsessionrc ]; then
    mv ~/.xsessionrc ~/.xsessionrc.bak
    ln -s $DIR/xsessionrc ~/.xsessionrc
fi

echo 'Installing git helpers'
mv ~/.git-prompt.sh ~/.git-prompt.sh.bak
wget -O ~/.git-prompt.sh https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
chmod +x ~/.git-prompt.sh
mv ~/.git-completion.sh ~/.git-completion.sh.bak
wget -O ~/.git-completion.sh https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
chmod +x ~/.git-completion.sh
