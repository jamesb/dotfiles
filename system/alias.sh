# Enable color support aliases for ls
LS_COLORS=`is-supported "ls --color" --color -G`
LS_TIMESTYLEISO=`is-supported "ls --time-style=long-iso" --time-style=long-iso`
LS_GROUPDIRSFIRST=`is-supported "ls --group-directories-first" --group-directories-first`
alias ls="ls -hF $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
unset LS_COLORS LS_TIMESTYLEISO LS_GROUPDIRSFIRST


# Enable color support aliases for grep tools
GREP_COLORS=`is-supported "grep --color --help" --color`
alias grep='grep $GREP_COLORS'
unset GREP_COLORS


# Enable color support aliases for grep tools
DIFF_COLORS=`is-supported "diff --color --help" --color`
alias diff='diff $DIFF_COLORS'
unset DIFF_COLORS


# More ls aliases
alias ll='ls -AlF'
alias la='ls -A'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
if [ -x /usr/bin/notify-send ]; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# Add a "journal" alias for logging system changes
alias journal='date >> ~/admin_journal.txt; $EDITOR ~/admin_journal.txt'