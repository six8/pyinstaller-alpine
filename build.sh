#!/bin/bash

export PYINSTALLER_TAG=${1:-v3.3}
export APLINE_VERSION=${2:-v3.4}

REPO="six8/pyinstaller-alpine:apline-${APLINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"

docker build \
    --build-arg PYINSTALLER_TAG=${PYINSTALLER_TAG} \
    -t $REPO .

docker push $REPO