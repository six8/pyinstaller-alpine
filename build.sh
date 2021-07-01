#!/bin/bash

set -Eeuo pipefail

[ -n "${DEBUG:-}" ] && set -x

REPOSITORY="${1:-six8/pyinstaller-alpine}"
PYINSTALLER_TAG="${2:-v3.6}"
ALPINE_VERSION="${3:-3.12}"
PYTHON_VERSION="${4:-3.7}"
SOURCE_COMMIT="${SOURCE_COMMIT:-$(git rev-parse --verify HEAD)}"
SOURCE_REF="${SOURCE_REF:-git branch --show-current}"
TAG="alpine${ALPINE_VERSION}-python${PYTHON_VERSION}-pyinstaller${PYINSTALLER_TAG#v}"

docker buildx build \
	--build-arg "PYINSTALLER_TAG=$PYINSTALLER_TAG" \
	--build-arg "PYTHON_VERSION=$PYTHON_VERSION" \
	--build-arg "ALPINE_VERSION=$ALPINE_VERSION" \
  --build-arg "SOURCE_COMMIT=$SOURCE_COMMIT" \
  --build-arg "SOURCE_REF=$SOURCE_REF" \
  --platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
  --tag "$REPOSITORY:$TAG" \
  .
