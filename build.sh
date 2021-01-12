#!/bin/bash

REPOSITORY=${1:-six8/pyinstaller-alpine-linux-amd64}
ARCH=${2:-''}
PYINSTALLER_TAG=${3:-v3.6}
ALPINE_VERSION=${4:-3.7}
PYTHON_VERSION=${5:-3.7}

docker build -f python${PYTHON_VERSION}.Dockerfile -t ${REPOSITORY}:alpine-${ALPINE_VERSION}-python-${PYTHON_VERSION}-pyinstaller-${PYINSTALLER_TAG} \
	--build-arg ARCH=${ARCH} \
	--build-arg PYINSTALLER_TAG=${PYINSTALLER_TAG} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	.

