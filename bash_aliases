# ~/.bash_aliases
#
# George Lesica
# Convenience aliases.

ARCH=$(uname)

# Reload bashrc
alias reload="source ~/.bashrc"

# Long directory listings
alias lsl="ls -l"
alias lsla="ls -la"

# Make should be silent by default
alias make="make -s"

# Bring back cls from DOS
alias cls="clear"

# Clear and do a directory listing
alias clls="clear; ls -l"

# Open files more easily
if hash exo-open 2> /dev/null; then
    alias op="exo-open"
fi

if hash xdg-open 2> /dev/null; then
    alias op="xdg-open"
fi

if [ "$ARCH" == "Darwin" ]; then
    alias op="open"
fi

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -Gh --color=auto'
    alias dir='dir -Gh --color=auto'
    alias vdir='vdir -Gh --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some additional ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Add a quick alias to remap the caps lock to ctrl since this gets weirded up
# when a new keyboard gets plugged in
case "$ARCH" in
    Linux) alias keyboard='setxkbmap -option "ctrl:nocaps"';;
    Darwin) alias keyboard='';;
esac

# Visual Studio Code Mac alias
case "$ARCH" in
    Darwin) alias vscode='open /Applications/Visual\ Studio\ Code.app';;
esac

# Some handy git aliases
alias gco='git checkout'
alias glf='git log --oneline --graph --decorate --all'
alias gp='git pull'
alias gst='git status'
alias master='git checkout master && git pull'

# File helpers
alias mvbooks='for filename in $(ls ~/Downloads/*.epub); do mv "$filename" ~/Books/; mv "${filename%.*}.pdf" ~/Books/; done'

# Dart
alias ddev='pub run dart_dev'

# System
alias aguagu='sudo apt-get update && sudo apt-get upgrade'
