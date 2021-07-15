#!/bin/bash

###############################################################################
# Setup the environment and define some helpful bash functions
###############################################################################

export SINGULARITY_CACHEDIR=/export/scratch/users/$USER

export PMSSM_ENV_TAG="latest"
__pmssm-env_use() {
  export PMSSM_ENV_TAG="$1"
}

__pmssm-env_config() {
  echo "SINGULARITY_CACHEDIR=${SINGULARITY_CACHEDIR}"
  echo "PMSSM_ENV_TAG=${PMSSM_ENV_TAG}"
}

__pmssm-env_run() {
  singularity run \
    -B $(pwd -P) \
    docker://tomeichlersmith/pmssm-env:${PMSSM_ENV_TAG} \
    $@
}

pmssm-env() {
  case "$1" in
    use|config)
      __pmssm-env_$1 ${@:2}
      ;;
    *)
      __pmssm-env_run ${@:2}
      ;;
  esac
}
