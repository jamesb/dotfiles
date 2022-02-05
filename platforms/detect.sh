UNAME_S="$(uname -s)"
UNAME_R="$(uname -r)"
case $UNAME_S in
  'Linux')
    case $UNAME_R in
      *Microsoft*)  PLATFORM='WSL' ;;
      *microsoft*)  PLATFORM='WSL' ;;
      *)            PLATFORM='Linux' ;;
    esac
    ;;
  CYGWIN*)     PLATFORM='Cygwin'  ;;
  'WindowsNT') PLATFORM='Windows' ;;
  'Darwin')    PLATFORM='MacOS'   ;;
  'SunOS')     PLATFORM='Solaris' ;;
  *)           PLATFORM='other'   ;;
esac

echo "Identified platform as \"$PLATFORM\""
export PLATFORM

# Clean up
unset UNAME_S
