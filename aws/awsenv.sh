#! /usr/bin/env bash

#############################################################################
show_usage() {
  progself="$1"

  read -r -d '' usage << USAGE_END

Usage: ${progself} [OPTION]...

Options:
  -h,?           display this usage information
  -n             adds the export -n option to un-export the variables

Examples:
  eval "\$(${progself})"
  eval "\$(${progself} -n)"

USAGE_END

  echo
  echo "${usage}"
  echo
}


#############################################################################

# Significant exit codes
EX_SUCCESS=0
EX_FAIL=1
EX_USAGE=64

# Get the name by which this script was called.
PROGSELF=$(basename $0)

# Get command-line options
export_opt=""
while getopts "?hn" opt; do
  case "${opt}" in
    h|\?)
      show_usage "${PROGSELF}"
      exit ${EX_SUCCESS} # exit with success here since usage was requested
      ;;
    n)
      export_opt="-n"
      ;;
  esac
done

shift $((OPTIND-1))


# Check for prerequisites
declare -a prereqs=("aws")
for prog in "${prereqs[@]}" ; do
  command -v ${prog} > /dev/null 2>&1 || { echo >&2 "Program '${prog}' required but not found."; exit ${EX_FAIL}; }
done


# Run aws configure and capture output
adrg=$(aws configure get region)
aaki=$(aws configure get aws_access_key_id)
asak=$(aws configure get aws_secret_access_key)

comment="# To export these variables, run this script in Bash with the eval command, like this: "
comment+=$'\n'
comment+="# eval \"\$(${PROGSELF})\""
comment+=$'\n'

exports=""
if [[ ${export_opt} =~ n ]]; then
  exports+="export ${export_opt} AWS_DEFAULT_REGION"
  exports+=$'\n'
  exports+="export ${export_opt} AWS_ACCESS_KEY_ID"
  exports+=$'\n'
  exports+="export ${export_opt} AWS_SECRET_ACCESS_KEY"
else
  exports+="export ${export_opt} AWS_DEFAULT_REGION=\"${adrg}\""
  exports+=$'\n'
  exports+="export ${export_opt} AWS_ACCESS_KEY_ID=\"${aaki}\""
  exports+=$'\n'
  exports+="export ${export_opt} AWS_SECRET_ACCESS_KEY=\"${asak}\""
fi

# Enable extended globbing
shopt -s extglob
# Remove duplicate spaces
exports="${exports//+([[:blank:]])/ }"
# Disable extended globbing
shopt -u extglob

# Write the output.  Quoting here to include newlines.
echo "${comment}${exports}"

exit ${EX_SUCCESS}
