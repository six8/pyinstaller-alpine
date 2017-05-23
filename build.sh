#!/bin/bash

export PYINSTALLER_TAG=v3.2
export APLINE_VERSION=v3.4

exec docker build -t six8/pyinstaller-alpine:apline-${APLINE_VERSION}-pyinstaller-${PYINSTALLER_TAG} .