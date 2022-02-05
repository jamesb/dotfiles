# Credit: http://stackoverflow.com/questions/2264428/converting-string-to-lower-case-in-bash-shell-scripting
lc() {
  LC_ALL=C  # for case-sensitive match
  case "$1" in
    [A-Z])
      n=$(printf "%d" "'$1")
      n=$((n+32))
      printf \\$(printf "%o" "$n")
      ;;
    *)
      printf "%s" "$1"
      ;;
  esac
}

tolower() {
  local text=$1
  for((i=0;i<${#text};i++))
  do
    local ch="${text:$i:1}"
    local lch=$(lc $ch)
    local ltext="${ltext}${lch}"
  done
  printf $ltext
}

# Credit: https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
trim_whitespace() {
  local trim="$*"
  # remove leading whitespace
  trim="${trim#"${trim%%[![:space:]]*}"}"
  # remove trailing whitespace
  trim="${trim%"${trim##*[![:space:]]}"}"
  printf "${trim}"
}

