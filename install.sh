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
