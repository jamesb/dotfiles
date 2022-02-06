#! /usr/bin/env bash

#############################################################################
show_usage() {
  progself="$1"

  read -r -d '' usage << USAGE_END

Usage: ${progself} -p <PROJECT-NAME> [OPTION]...
Manages typical workflow scenarios for a Fitbit SDK project. First, the user
must manually download the "Export Project" file and the "Publish" file from
Fitbit Studio. Once that is done, this script can:
* Ensure the current directory is a clean Git repo
* Unzip the downloaded files
* Move the downloaded files to a temp directory
* Compress the "publish" version of the project

Options:
  -h,?           display this usage information
  -c             compress the "publish" version of index.js
  -d             specify the downloaded files' directory (default: ..)
  -k             keep the temporarily backed-up files
  -p <name>      specify the Fitbit Studio project name

Examples:
  ${progself} -p MyProject -c -d ~/Downloads

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

# Check for prerequisites
declare -a prereqs=("basename" "cmp" "cp" "diff" "sed" "uglifyjs" "unzip")
for prog in "${prereqs[@]}" ; do
  command -v ${prog} > /dev/null 2>&1 || { echo >&2 "Program '${prog}' required but not found."; exit ${EX_FAIL}; }
done

# Get the name by which this script was called.
PROGSELF=$(basename $0)

IDXHEADER='// import "../app/index_full.js";'
IDX_FPATH='app/index.js'
FULFILE='app/index_full.js'
download_dir='..'


# Get command-line options
keep_backup=false
while getopts "?hcd:kp:" opt; do
  case "${opt}" in
    h|\?)
      show_usage "${PROGSELF}"
      exit ${EX_SUCCESS} # exit with success here since usage was requested
      ;;
    c)
      compress_pub=true
      ;;
    d)
      download_dir=${OPTARG}
      ;;
    k)
      keep_backup=true
      ;;
    p)
      project=${OPTARG}
      ;;
  esac
done

shift $((OPTIND-1))

# Require the project name parameter
if [[ -z "${project}" ]]; then
  echo >&2 "The -p <project-name> option is required."
  show_usage "${PROGSELF}"
  exit ${EX_USAGE}
fi

# project_id == project, but with consecutive spaces replaced by hyphens
project_id=$(echo $project | sed -r "s#[[:space:]]+#-#g")


# Export file must be readable
export_fname="${project_id}-export.zip"
export_fpath="${download_dir}/${export_fname}"
if [[ ! -r "${export_fpath}" ]] ; then
  echo >&2 "File ${export_fpath} didn't exist or was unreadable."
  echo >&2 "If the file is located in a different directory, use the -d option."
  exit ${EX_FAIL}
fi


# If we're compressing the app, then the publish file must be readable
if [[ ${compress_pub} = true ]] ; then
  publish_fname="${project_id}.fba"
  publish_fpath="${download_dir}/${publish_fname}"
  if [[ ! -r "${publish_fpath}" ]] ; then
    echo >&2 "File ${publish_fpath} didn't exist or was unreadable."
    echo >&2 "If the file is located in a different directory, use the -d option."
    exit ${EX_FAIL}
  fi
fi


# If we're compressing the app, then a separate index JS file is required.
if [[ ${compress_pub} = true && ! -f "${FULFILE}" ]] ; then
  echo >&2 "App's index.js must be separated into ${FULFILE} to preserve it."
  exit ${EX_FAIL}
fi


# Check Git repo for untracked entries.
git_untracked=$(git ls-files --other --exclude-standard --directory)
if [[ ! -z ${git_untracked} ]] ; then
  echo >&2 "There are untracked files in this Git repo."
  exit ${EX_FAIL}
fi


# Check Git repo for unstaged changes.
git_unstaged=$(git diff --exit-code)
if [[ ! -z ${git_unstaged} ]] ; then
  echo >&2 "There are unstaged files in this Git repo."
  exit ${EX_FAIL}
fi


# Check Git repo for staged but uncommitted changes.
git_uncommitted=$(git diff --cached --exit-code)
if [[ ! -z ${git_uncommitted} ]] ; then
  echo >&2 "There are staged, uncommitted files in this Git repo."
  exit ${EX_FAIL}
fi


# Unzip the export file, overwriting existing files.
unzip -o -d . ${export_fpath}

# Backup files to a temp directory
mytmpdir=$(mktemp --directory --tmpdir pid$$.XXXXXXXXXX)
mkdir -p ${mytmpdir}
idxjs_fpath="${mytmpdir}/index.js"
expzip_fpath=${mytmpdir}/${export_fname}
pubfba_fpath=${mytmpdir}/${publish_fname}
publish_dir="${mytmpdir}/publish"
pubidx_fpath="${mytmpdir}/pubindex.js"
ugly_fpath="${mytmpdir}/compressed.js"

$(mv ${export_fpath} ${mytmpdir})

if [[ ${compress_pub} != true ]] ; then
  my_ex=${EX_SUCCESS}
else
  $(mv ${publish_fpath} ${mytmpdir})
  $(cp ${IDX_FPATH} ${mytmpdir})

  # Extract the device-specific publish files.
  unzip -qq -d ${publish_dir} ${pubfba_fpath}
  higgs_dir="${publish_dir}/device-higgs"
  meson_dir="${publish_dir}/device-meson"
  unzip -qq -d ${higgs_dir} ${publish_dir}/device-higgs.zip ${IDX_FPATH}
  unzip -qq -d ${meson_dir} ${publish_dir}/device-meson.zip ${IDX_FPATH}

  # Compare the device-specific publish files (they should be identical)
  $(cmp -s ${higgs_dir}/${IDX_FPATH} ${meson_dir}/${IDX_FPATH})
  dvc_differ=$?
  if [[ ${dvc_differ} -gt "0" ]] ; then
    echo >&2 "Higgs and Meson device files differ! (This shouldn't happen.)"
    exit ${EX_FAIL}
  fi

  # Since the device files are now confirmed equal, we can work with either:
  $(cp ${higgs_dir}/${IDX_FPATH} ${pubidx_fpath})

  my_ex=${EX_SUCCESS}

  # Compress the publish file and put the result in the project's index.js
  if [[ ${compress_pub} = true ]] ; then
    uglifyjs --compress --mangle --toplevel --warn -- ${pubidx_fpath} > ${ugly_fpath}
    ugl_ex=$?
    case "${ugl_ex}" in
      0)
        echo ${IDXHEADER} > ${IDX_FPATH}
        cat ${ugly_fpath} >> ${IDX_FPATH}
        ;;
      *)
        echo "uglifyjs exited with an error code ($ugl_ex)..."
        my_ex=${EX_FAIL}
        ;;
    esac
  fi
fi

# Keep backups or remove them
if [[ ${keep_backup} = true ]] ; then
  echo "${mytmpdir}"
else
  rm -f ${expzip_fpath}
  if [[ ${compress_pub} = true ]] ; then
    rm -f ${idxjs_fpath} ${pubfba_fpath} ${pubidx_fpath} ${ugly_fpath}
    rm -rf ${publish_dir}
  fi
fi

# Remove temporary directory if it's empty
rmdir --ignore-fail-on-non-empty ${mytmpdir}

exit ${my_ex}
