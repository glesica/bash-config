# .bash_aliases
# George Lesica
# Convenience aliases.

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
alias op="exo-open"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

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
alias keyboard='setxkbmap -option "ctrl:nocaps"'

# Some handy git aliases
alias gitco='git checkout'
alias gitbco='git checkout -b'
alias gitst='git status'

# Move to neovim
alias vim=nvim

# Fancy Git stuff
alias glf='git log --oneline --graph --decorate --all'

# File helpers
alias mvbooks='for filename in $(ls ~/Downloads/*.epub); do mv "$filename" ~/Books/; mv "${filename%.*}.pdf" ~/Books/; done'
