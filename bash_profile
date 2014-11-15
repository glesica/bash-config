# ~/.bash_profile
# George Lesica <george@lesica.com>
# Profile based on Debian/Ubuntu default version of this file.

# ~/.bash_profile: executed by the command interpreter for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi
