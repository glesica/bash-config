# .bashrc
# George Lesica <george@lesica.com>
# My .bashrc file. Project or software-related settings are generally toward
# the end of the file. This file is largely based on the default Debian/Ubuntu
# file and on http://tldp.org/LDP/abs/html/sample-bashrc.html.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# read in alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# add local bins to path
PATH="$PATH:/home/${USER}/bin:/home/${USER}/local/bin"

# colors (lazy shortcut)
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

# Git completion
source ~/.git-completion.sh
source ~/.git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_REPO='$(__git_ps1 " (%s)")'

# Setup virtualenvwrapper for Python virtual environments
export WORKON_HOME=~/.envs
mkdir -p $WORKON_HOME

# set up a nice prompt
PS_SUCCESS=$GREEN
PS_FAILURE=$RED
PS_HOST=$YELLOW
PS_GIT=$LIGHTPURPLE
PS_DEFAULT=$CYAN
PS1="\n\$(if [[ \$? == 0 ]]; then echo \"${PS_SUCCESS}\"; else echo \"${PS_FAILURE}\"; fi)\342\226\210\342\226\210 ${PS_DEFAULT}[ \u@${PS_HOST}\h${PS_DEFAULT} \w ]${PS_GIT}${GIT_REPO} ${PS_DEFAULT}\n${NOCOLOR}$ "

# Create VIMHOME
export VIMHOME=/home/${USER}/.vim

# A small function to aid in lowercasing file extensions, 
# such as those produced by digital cameras (.JPG)
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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Exports for ESys-Particle
# See: https://answers.launchpad.net/esys-particle/+faq/1613
export PATH=/home/george/local/bin/:/usr/local/bin/:$PATH
export LD_LIBRARY_PATH=/home/george/local/lib/:/usr/local/lib/:$LD_LIBRARY_PATH
export LIBRARY_PATH=/home/george/local/lib/:/usr/local/lib/:$LIBRARY_PATH
export PYTHONPATH=/home/george/local/lib/python2.7/site-packages/:$PYTHONPATH

# Use 256 color terminal
export TERM=xterm-256color
