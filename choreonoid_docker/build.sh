#!/bin/bash
set -eu

DOCKER=${DOCKER:-nvidia-docker}

${DOCKER} build --tag=yoheikakiuchi/choreonoidsim .
