#!/bin/bash

###############################################################################
# Setup the environment and define some helpful bash functions
###############################################################################

export SINGULARITY_CACHEDIR=/export/scratch/users/$USER
__pmssm-env_cache() {
  if [[ -d "$1" ]]; then
    export SINGULARITY_CACHEDIR="$(cd $1 && pwd -P)"
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
  return 0
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
    <other> : run the input command in the container
      pmssm-env <other> [<arguments> ...]
HELP
  return 0
}

__pmssm-env_run() {
  singularity run \
    -B $(pwd -P) \
    docker://tomeichlersmith/pmssm-env:${PMSSM_ENV_TAG} \
    $@
  return $?
}

pmssm-env() {
  case "$1" in
    use|config|help|cache)
      __pmssm-env_$1 ${@:2}
      return $?
      ;;
    *)
      __pmssm-env_run ${@:2}
      return $?
      ;;
  esac
}
