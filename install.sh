#!/usr/bin/env bash

# Simple script to install Bash configuration files in the home directory. Uses
# symlinks instead of copying the files. Creates a backup of the existing
# configuration by appending '.bak'.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

backupfile() {
    mv "$1" "$1.bak" 2> /dev/null
}

linkfile() {
    ln -s "$DIR/$1" "$HOME/.$1"
}

echo 'Linking .bashrc'
backupfile "$HOME/.bashrc"
linkfile bashrc

echo 'Linking .bash_aliases'
backupfile "$HOME/.bash_aliases"
linkfile bash_aliases

echo 'Linking .bash_profile'
backupfile "$HOME/.bash_profile"
linkfile bash_profile

echo 'Linking .bash_completion'
backupfile "$HOME/.bash_completion"
linkfile bash_completion

echo 'Linking .bash_private'
if [ -f $DIR/bash_private ]; then
    backupfile "$HOME/.bash_private"
    linkfile bash_private
fi

echo 'Linking .xsessionrc'
backupfile "$HOME/.xsessionrc"
linkfile xsessionrc

echo 'Linking .tmux.conf'
backupfile "$HOME/.tmux.conf"
linkfile tmux.conf

echo 'Linking .gitconfig'
backupfile "$HOME/.gitconfig"
linkfile gitconfig

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
