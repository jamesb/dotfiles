# Helper function for sourcing scripts
sourcefile() {
  [[ -f "$1" && -r "$1" ]] && source "$1"
}


is-executable() {
  local BIN=$(command -v "$1" 2>/dev/null)
  if [[ ! $BIN == "" && -x $BIN ]]; then true; else false; fi
}


# With a single argument ($1):
#   Returns true if the command ($1) exits with success and prints nothing to
#   stderr.
# With multiple arguments ($1 $2 [$3])
#   Returns $2 if the command ($1) exits with success and prints nothing to
#   stderr, otherwise returns $3.
is-supported() {
  CMD_ERR="$($1 2>&1 > /dev/null)"
  if [ $# -eq 1 ]; then
    if eval "$1" > /dev/null 2>&1 && [[ -z $CMD_ERR ]]; then true; else false; fi
  else
    if eval "$1" > /dev/null 2>&1 && [[ -z $CMD_ERR ]]; then
      echo -n "$2"
    else
      echo -n "$3"
    fi
  fi
}


# Add to path
prepend-path() {
  [[ -d $1 ]] && PATH="$1:$PATH"
}


# Update config file
set-config() {
  local KEY="$1"
  local VALUE="$2"
  local FILE="$3"
  touch "$FILE"
  if grep -q "$1=" "$FILE"; then
    sed "s@$KEY=.*@$KEY=\"$VALUE\"@" -i "$FILE"
  else
    echo "export $KEY=$VALUE" >> "$FILE"
  fi
}


# Show 256 TERM colors
colors() {
  local X=$(tput op)
  local Y=$(printf %$((COLUMNS-6))s)
  for i in {0..256}; do
  o=00$i;
  echo -e ${o:${#o}-3:3} $(tput setaf $i;tput setab $i)${Y// /=}$X;
  done
}


# Train yourself to run 'kak' instead of 'vim' :-)
vim2kak() {
  echo "BZZZT!! Press 'k' if you really meant 'kak' instead!"
  if ~/dotfiles/system/escape-hatch.sh 3 k ; then
    echo "Launching kak..."
    kak $@
  else
    echo "Launching vim..."
    vim $@
  fi
}


# When no session name is specified for kak, start Kakoune as a client on the
# default server (or start the default server, if it doesn't yet exist.)
kak_default_server() {
  # Get command-line options
  OPTIND=1
  while getopts ":c:s:" opt; do
  case "${opt}" in
    c|s)
      local arg_session_name=${OPTARG}
      ;;
    ?) # allow other options to pass through without error
      ;;
    esac
  done

  # Clear dead sessions
  kak -clear

  # Start kak with the specified session name or a default
  if [[ ! -z "${arg_session_name}" ]] ; then
    # If a session name is specified with -c or -s, then don't use the default
    # session at all.
    kak $@
  else
    # Determine default sesion name from tmux window, if possible
    local default_session_name=$(tmux display-message -p '#W' 2> /dev/null)
    if [[ -z "${default_session_name}" ]] ; then
      default_session_name=default
    fi

    if kak -c ${default_session_name} $@ ; then
    : # Do nothing (successfully connected to default session)
    else
      # Connect failed... start the default session and connect again
      kak -d -s ${default_session_name} $@
      kak -c ${default_session_name} $@
    fi
  fi
}
