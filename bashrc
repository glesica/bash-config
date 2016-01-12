# ~/.bashrc
#
# George Lesica <george@lesica.com>
# My .bashrc file. Project or software-related settings are generally toward
# the end of the file. This file is largely based on the default Debian/Ubuntu
# file and on http://tldp.org/LDP/abs/html/sample-bashrc.html.

ARCH=$(uname)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Set up keyboard for use by a non-degenerate.
if [[ "$DISPLAY" != "" ]]; then
    keyboard
fi

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

# Git completion.
source ~/.git-completion.sh
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_REPO='$(__git_ps1 " (%s)")'

# Setup virtualenvwrapper for Python virtual environments.
export WORKON_HOME=~/.envs
mkdir -p "$WORKON_HOME"
if [ "$ARCH" = "Darwin" ]; then
    source /usr/local/bin/virtualenvwrapper.sh 2> /dev/null || true
fi

# Set up a nice prompt.
PS_SUCCESS=$GREEN
PS_FAILURE=$RED
PS_HOST=$YELLOW
PS_GIT=$LIGHTPURPLE
PS_DEFAULT=$CYAN
PS1="\n\$(if [[ \$? == 0 ]]; then echo \"${PS_SUCCESS}\"; else echo \"${PS_FAILURE}\"; fi)\342\226\210\342\226\210 ${PS_DEFAULT}[ \u@${PS_HOST}\h${PS_DEFAULT} \w ]${PS_GIT}${GIT_REPO} ${PS_DEFAULT}\n${NOCOLOR}$ "

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

# Create home local and bin
mkdir -p "$HOME/local"
mkdir -p "$HOME/bin"

# Add local bins to path.
export PATH="$HOME/bin:$HOME/local/bin:$PATH"

# Add Mac specific binaries to path.
if [ "$ARCH" = "Darwin" ]; then
    export PATH="/usr/local/bin:$PATH" # Homebrew
    export PATH="$PATH:$HOME/Workspace/gradle/bin"
    export PATH="$PATH:$HOME/Library/Haskell/bin"
fi

# Set the editor
export EDITOR=vim

# Haskell / Stack
if hash stack 2> /dev/null; then
    eval "$(stack --bash-completion-script stack)"
fi

# Golang
if [ -d "$HOME/local/go" ]; then
    export GOROOT="$HOME/local/go"
    export GOPATH="$HOME/Go"
    export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
    mkdir -p "$GOPATH"
fi

# Rust
if [ -d "$HOME/local/src/rust" ]; then
    export RUST_SRC_PATH="$HOME/local/src/rust"
fi

# Nim
if [ -d "$HOME/local/nim" ]; then
    export PATH="$PATH:$HOME/local/nim/bin:$HOME/.nimble/bin"
fi

# Julia
if [ -d "$HOME/local/julia" ]; then
    export PATH="$PATH:$HOME/local/julia/bin"
fi

# Dart
export DART_FLAGS='--checked'
export PATH="$PATH:/usr/lib/dart/bin:$HOME/.pub-cache/bin"

# Improve output, especially on Mac.
export CLICOLOR=1
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

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

# Load private config if found.
if [ -f "$HOME/.bash_private" ]; then
    . "$HOME/.bash_private"
fi

