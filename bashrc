# ~/.bashrc
#
# George Lesica <george@lesica.com>
# My .bashrc file. Project or software-related settings are generally toward
# the end of the file. This file is largely based on the default Debian/Ubuntu
# file and on http://tldp.org/LDP/abs/html/sample-bashrc.html.

ARCH=$(uname)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Utility functions

function append_to_path() {
    local newpath="$1"
    if [[ ! "$PATH" == *"$newpath"* ]]; then
        export PATH="$PATH:$newpath"
    fi
}

function prepend_to_path() {
    local newpath="$1"
    if [[ ! "$PATH" == *"$newpath"* ]]; then
        export PATH="$newpath:$PATH"
    fi
}

function source_if_exists() {
    local srcpath="$1"
    if [[ -f "$srcpath" ]]; then
        source "$srcpath"
    fi
}

# Don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace.
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1).
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Use 256 color terminal.
export TERM=xterm-256color

# Set a fancy prompt (non-color, unless we know we "want" color).
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# Read in alias definitions.
source_if_exists "$HOME/.bash_aliases"

# Set up keyboard for use by a non-degenerate.
[ "$DISPLAY" != "" ] && keyboard

# Colors (lazy shortcut).
BLACK='\[\e[0;30m\]'
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
BROWN='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
PURPLE='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
LIGHTGRAY='\[\e[0;37m\]'
DARKGRAY='\[\e[1;30m\]'
LIGHTRED='\[\e[1;31m\]'
LIGHTGREEN='\[\e[1;32m\]'
YELLOW='\[\e[1;33m\]'
LIGHTBLUE='\[\e[1;34m\]'
LIGHTPURPLE='\[\e[1;35m\]'
LIGHTCYAN='\[\e[1;36m\]'
WHITE='\[\e[1;37m\]'
NOCOLOR='\[\e[1;00m\]'

# Symbols

export BALLOTX='✘'
export CHECKMARK='✔'

# Git setup.
source_if_exists ~/.git-completion.sh
source_if_exists ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_REPO='$(__git_ps1 " (%s)")'
git config --global core.excludesfile '~/.gitignore'

# Sets the working directory for all virtualenvs
export WORKON_HOME=$HOME/.virtualenvs
mkdir -p "$WORKON_HOME"

# Sources the virtualenvwrapper so all the commands are available in the shell
if [ "$ARCH" == "Darwin" ]; then
    # Setup virtualenvwrapper for Python virtual environments.
    # Don't let Mac python (in /usr/bin) supercede brew's python (/usr/local/bin)
    if [ -f "/usr/local/bin/python" ]; then
        export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
        source_if_exists /usr/local/bin/virtualenvwrapper.sh
    fi
fi

# Set up a nice prompt.
PS_DATE=$DARKGRAY
PS_SUCCESS=$GREEN
PS_FAILURE=$RED
PS_HOST=$YELLOW
PS_GIT=$LIGHTPURPLE
PS_DEFAULT=$CYAN
PS1="\n\$(if [[ \$? == 0 ]]; then echo \"${PS_SUCCESS}$CHECKMARK \"; else echo \"${PS_FAILURE}$BALLOTX \"; fi)${PS_DEFAULT}\$(date \"+%Y-%m-%d %T\")\n| \u@${PS_HOST}\h${PS_DEFAULT} \w${PS_GIT}${GIT_REPO} ${PS_DEFAULT}\n${NOCOLOR}$ "

# GPG Agent or whatever

export GPG_TTY=`tty`

INFO_FILE="$HOME/.gnupg/.gpg-agent-info"

if [ -f "INFO_FILE" ]; then
    if [ -n "$(pgrep gpg-agent)" ]; then
        source_if_exists "$INFO_FILE"
    else
        eval $(gpg-agent --daemon "$INFO_FILE" || true)
    fi
fi

# A small function to aid in lowercasing file extensions, 
# such as those produced by digital cameras (.JPG)
# ------------------------------------------------
extlower() {
    for ofn in $@; do
        ofe=`echo "${ofn}" | rev | cut -d'.' -f1 | rev`
        nfe=`echo "${ofe}" | tr '[:upper:]' '[:lower:]'`
        nfn=`echo "${ofn}" | sed s/${ofe}$/${nfe}/`
        if [[ "${ofn}" != "${nfn}" ]]; then
            echo "${ofn} --> ${nfn}"
            mv -i ${ofn} ${nfn}
        else
            echo "${ofn} is already lower case"
        fi
    done
}

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# From: http://madebynathan.com/2011/10/04/a-nicer-way-to-use-xclip/
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }  
# Copy SSH public key
alias cbssh="cb ~/.ssh/id_rsa.pub"  
# Copy current working directory
alias cbwd="pwd | cb"  
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"

# mkdir + cd in one!
# https://www.reddit.com/r/bash/comments/5obi56/mkcd/dci2i1b/
mkcd() { 
    mkdir "$@" || return
    shift "$(( $# - 1 ))"
    cd -- "$1"
}

# Create home local and bin
mkdir -p "$HOME/bin"
mkdir -p "$HOME/local/bin"
mkdir -p "$HOME/.local/bin"

# Add local bins to path.
prepend_to_path "$HOME/.local/bin"
prepend_to_path "$HOME/local/bin"
prepend_to_path "$HOME/bin"

# Add Mac specific binaries to path.
if [ "$ARCH" = "Darwin" ]; then
    prepend_to_path "/usr/local/bin" # Homebrew
    append_to_path "$HOME/gradle/bin"
    append_to_path "$HOME/Library/Haskell/bin"
fi

# Set the editor
export EDITOR=vim

# Gradle
if [ -d "$HOME/local/gradle" ]; then
    export GRADLE_HOME="$HOME/local/gradle"
    append_to_path "$GRADLE_HOME/bin"
fi

# Haskell / Stack
if hash stack 2> /dev/null; then
    eval "$(stack --bash-completion-script stack)"
fi

# Golang
if [[ -f "$HOME/.swgo.bash" ]]; then
    source "$HOME/.swgo.bash"
    if [[ -f "$HOME/.swgo" ]]; then
	swgo -q
	mkdir -p "$GOPATH"
    fi
fi

# GoLand
append_to_path "$HOME/local/goland/bin"

# Google Cloud
append_to_path "$HOME/local/google-cloud-sdk/bin"

# Rust
append_to_path "$HOME/.cargo/bin"

if [ -d "$HOME/local/src/rust" ]; then
    export RUST_SRC_PATH="$HOME/local/src/rust/src"
fi

# Nim
if [ -d "$HOME/local/nim" ]; then
    append_to_path "$HOME/local/nim/bin"
    append_to_path "$HOME/.nimble/bin"
fi

# Dart

export DART_FLAGS='--checked'
append_to_path "/usr/lib/dart/bin"
append_to_path "$HOME/.pub-cache/bin"

if hash dart_dev 2> /dev/null; then
    eval "$(dart_dev bash-completion)"
fi

# Flutter

append_to_path "$HOME/local/flutter/bin"

# OCaml

if [ -d "$HOME/.opam/opam-init" ]; then
    source "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true
fi

# Node

export NVM_DIR="$HOME/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [ -d "$HOME/local/node" ]; then
    append_to_path "$HOME/local/node/bin"
fi

# Firefox

if [ -d "$HOME/local/firefox" ]; then
    append_to_path "$HOME/local/firefox"
fi

# Arduino

if [ -d "$HOME/local/arduino" ]; then
    append_to_path "$HOME/local/arduino"
fi

# Intellij

if [ -d "$HOME/local/idea" ]; then
    append_to_path "$HOME/local/idea/bin"
fi

# Improve output, especially on Mac.
export CLICOLOR=1

if [ -d "/usr/local/heroku/bin" ]; then
    prepend_to_path "/usr/local/heroku/bin"
fi

# Enable standard Bash completions.
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Enable Homebrew completions (Mac).
if hash brew 2> /dev/null; then
    # I often alias brew in a way that requires sudo.
    unalias brew 2>/dev/null
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

# Add Chromium's depot_tools
if [ -d "$HOME/local/depot_tools" ]; then
    append_to_path "$HOME/local/depot_tools"
fi

# Current Julia version
append_to_path "$HOME/local/julia"

# Load private config if found.
if [ -f "$HOME/.bash_private" ]; then
    . "$HOME/.bash_private"
fi

# Add texbin on Mac
if [ "$ARCH" = "Darwin" ]; then
    append_to_path "/Library/TeX/texbin"
fi

# Powershell
append_to_path "$HOME/local/powershell"

# Android SDK
append_to_path "$HOME/Android/Sdk/emulator"

