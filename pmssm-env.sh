#!/bin/bash

###############################################################################
# Setup the environment and define some helpful bash functions
###############################################################################

if [[ ! -d /export/scratch ]]; then
  echo "WARNING: /export/scratch is unavailable."
  echo "  You should define a large enough scratch directory with "
  echo "    pmssm-env cache <dir>"
else
  export TMPDIR=/export/scratch
  export SINGULARITY_CACHEDIR=/export/scratch/users/$USER
fi
__pmssm-env_cache() {
  if [[ -d "$1" ]]; then
    export SINGULARITY_CACHEDIR="$(cd $1 && pwd -P)"
    export TMPDIR=${SINGULARITY_CACHEDIR}
  else
    echo "'$1' is not a directory."
    return 1
  fi
  return 0
}

export PMSSM_ENV_TAG="latest"
__pmssm-env_use() {
  export PMSSM_ENV_TAG="$1"
  return 0
}

__pmssm-env_config() {
  echo "SINGULARITY_CACHEDIR=${SINGULARITY_CACHEDIR}"
  echo "PMSSM_ENV_TAG=${PMSSM_ENV_TAG}"
  echo "PMSSM_ENV_MOUNTS=${PMSSM_ENV_MOUNTS}"
  return 0
}

export PMSSM_ENV_MOUNTS=""
__pmssm-env_mount() {
  if [[ ! -d $1 ]]; then
    echo "ERROR: $1 is not a directory!"
    return 1
  fi

  export PMSSM_ENV_MOUNTS="${PMSSM_ENV_MOUNTS}${PMSSM_ENV_MOUNTS:+,}$(cd "$1" && pwd -P)${2:+:}${2}"
  return 0
}

__pmssm-env_source() {
  local _file_listing_commands="$1"
  local _old_pwd=$OLDPWD
  cd $(dirname $_file_listing_commands)
  while read _subcmd; do
    if [[ -z "$_subcmd" ]] || [[ "$_subcmd" = \#* ]]; then
      continue
    fi
    pmssm-env $_subcmd
  done < $(basename $_file_listing_commands)
  cd - &> /dev/null
  export OLDPWD=$_old_pwd
}

__pmssm-env_run() {
  singularity run \
    ${PMSSM_ENV_MOUNTS:+"-B"} ${PMSSM_ENV_MOUNTS} \
    docker://tomeichlersmith/pmssm-env:${PMSSM_ENV_TAG} \
    $@
  return $?
}

__pmssm-env_help() {
  cat <<\HELP
  USAGE:
    pmssm-env [command] [arguments]

    If no command is provided, then you will enter into a bash
    shell inside of the container that you have configured.

    The first time using a specific tag, your computer will
    need to download it from DockerHub and store the image in
    your cache. If you change tags or change your cache directory,
    this downloading will need to be redone.

  COMMANDS:
    help    : print this help message and exit
      pmssm-env help
    use     : define which tag of the container you wish to use
      pmssm-env use <tag>
    config  : printout the container configuration
      pmssm-env config
    cache   : set directory for caching the images
      pmssm-env cache <dir>
    mount   : add a directory to mount to container while running
      pmssm-env mount <dir>
    source  : run the commands in the provided file through pmssm-env
      pmssm-env source .pmssm-envrc
    <other> : run the input command in the container
      pmssm-env <other> [<arguments> ...]

HELP
  return 0
}

pmssm-env() {
  case "$1" in
    use|config|help|cache|mount|source)
      __pmssm-env_$1 ${@:2}
      return $?
      ;;
    *)
      __pmssm-env_run ${@}
      return $?
      ;;
  esac
}

_default_pmssmenvrc="$(dirname ${BASH_SOURCE[0]})/.pmssmenvrc"
if [[ -f ${_default_pmssmenvrc} ]]; then
  pmssm-env source ${_default_pmssmenvrc}
fi
