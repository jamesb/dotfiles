# Include dotfiles functions
. ${DOTFILES_DIR}/system/function.sh

# Default permissions to 0644
umask 022

# Set kak as interactive editor
export VISUAL=kak
# Set kak-like bash readline bindings (in conjunction with ../runcom/inputrc)
set -o vi


# Enable color support, if available
if is-executable dircolors ; then
  DIRCOLORS_FILE="${DOTFILES_DIR}/system/dircolors-solarized/dircolors.ansi-dark"
  eval "$(dircolors "$DIRCOLORS_FILE")"
fi


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth


# append to the history file, don't overwrite it
shopt -s histappend


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# Allow cd to directly change to children of these dirs:
export CDPATH=~/repos:~/winhome


# Autocorrect typos in path names when using `cd`
shopt -s cdspell;


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Set personal GitHub variables
export GITHUB_USER=jamesb
