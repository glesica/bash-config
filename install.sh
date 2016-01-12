#!/usr/bin/env bash

# Simple script to install Bash configuration files in the home directory. Uses
# symlinks instead of copying the files. Creates a backup of the existing
# configuration by appending '.bak'.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

backupfile() {
    mv "$1" "$1.bak" 2> /dev/null
}

echo 'Linking .bashrc'
backupfile "$HOME/.bashrc"
ln -s $DIR/bashrc ~/.bashrc

echo 'Linking .bash_aliases'
backupfile "$HOME/.bash_aliases"
ln -s $DIR/bash_aliases ~/.bash_aliases

echo 'Linking .bash_profile'
backupfile "$HOME/.bash_profile"
ln -s $DIR/bash_profile ~/.bash_profile

echo 'Linking .bash_completion'
backupfile "$HOME/.bash_completion"
ln -s "$DIR/bash_completion" "$HOME/.bash_completion"

echo 'Linking .bash_private'
if [ -f $DIR/bash_private ]; then
    backupfile "$HOME/.bash_private"
    ln -s $DIR/bash_private ~/.bash_private
fi

echo 'Linking .xsessionrc'
backupfile "$HOME/.xsessionrc"
ln -s $DIR/xsessionrc ~/.xsessionrc

echo 'Linking .tmux.conf'
backupfile "$HOME/.tmux.conf"
ln -s $DIR/tmux.conf ~/.tmux.conf

echo 'Installing git helpers'

backupfile "$HOME/git-prompt.sh"
if hash wget 2> /dev/null; then
    wget -O "$HOME/.git-prompt.sh" https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
elif hash curl 2> /dev/null; then
    curl -o "$HOME/.git-prompt.sh" https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
else
    touch "$HOME/.git-prompt.sh"
fi
chmod +x "$HOME/.git-prompt.sh"

backupfile "$HOME/git-completion.sh"
if hash wget 2> /dev/null; then
    wget -O "$HOME/.git-completion.sh" https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
elif hash curl 2> /dev/null; then
    curl -o "$HOME/.git-completion.sh" https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
else
    touch "$HOME/.git-completion.sh"
fi
chmod +x "$HOME/.git-completion.sh"
