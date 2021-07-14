#!/bin/bash

set -e

###############################################################################
# entry.sh
#   Entrypoint for pmssm-env. We just need to setup our environment before
#   running the command(s) we are given.
###############################################################################

source /usr/local/bin/thisroot.sh

eval "$@"
