# Enable color support aliases for ls
COLOR_OPTS=`is-supported "ls --color" --color -G`
LS_TIMESTYLEISO=`is-supported "ls --time-style=long-iso" --time-style=long-iso`
LS_GROUPDIRSFIRST=`is-supported "ls --group-directories-first" --group-directories-first`
alias ls="ls -hF $COLOR_OPTS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
unset COLOR_OPTS LS_TIMESTYLEISO LS_GROUPDIRSFIRST


# Enable color support alias for grep
COLOR_OPTS=`is-supported "grep --color" --color`
alias grep="grep $COLOR_OPTS"
unset COLOR_OPTS


# Enable color support alias for diff
COLOR_OPTS=`is-supported "diff --color" --color`
alias diff="diff $COLOR_OPTS"
unset COLOR_OPTS


# Enable color support alias for less
# less command needs a filename... use this file ($BASH_SOURCE)
COLOR_OPTS=`is-supported "less -R $BASH_SOURCE" -R`
alias less="less $COLOR_OPTS"
unset COLOR_OPTS


# More ls aliases
alias ll='ls -AlF'
alias la='ls -A'


# Alias for github tool 'hub'
if is-executable 'hub' ; then
  eval "$(hub alias -s)"
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
if is-executable 'notify-send' ; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Add a "journal" alias for logging system changes
alias journal='date >> ~/admin_journal.txt; $EDITOR ~/admin_journal.txt'

# The "functions" command lists available bash function names (without a
# leading underscore).
alias functions='declare -F | awk "\$3 ~ /^[^_]/ { print \$3}"'

# Train yourself to run 'kak' instead of 'vim' :-)
alias vim='vim2kak'

# Use a single kak server by default
alias kak='kak_default_server'
