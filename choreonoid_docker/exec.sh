#!/bin/bash
set -eu

VAR=${@:-"bash"}
#echo "VAR: $VAR"

RUNDOC=${DOCKER:-nvidia-docker}

${RUNDOC} exec -it \
    --privileged \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    choreonoid_simulation ${VAR}
