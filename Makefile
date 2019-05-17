.DEFAULT: all
.PHONY: all

REPOSITORY ?= six8
NAME := pyinstaller-alpine
PYINSTALLER_TAG := v3.4
ALPINE_VERSION := 3.6
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SUFFIX ?= -$(subst /,-,$(BRANCH))

all: build

build: Dockerfile
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-amd64" "" "${PYINSTALLER_TAG}" "${ALPINE_VERSION}"
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-armv7" "arm32v7/" "${PYINSTALLER_TAG}" "${ALPINE_VERSION}"
	@./build.sh "$(REPOSITORY)/$(NAME)-linux-arm64" "arm64v8/" "${PYINSTALLER_TAG}" "${ALPINE_VERSION}"

push:
	# Push docker images
	docker push "$(REPOSITORY)/$(NAME)-linux-amd64:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"
	docker push "$(REPOSITORY)/$(NAME)-linux-armv7:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"
	docker push "$(REPOSITORY)/$(NAME)-linux-arm64:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"

manifest:
	# Manifest for alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create -a "$(REPOSITORY)/$(NAME):alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}" \
		"$(REPOSITORY)/$(NAME)-linux-amd64:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}" \
		"$(REPOSITORY)/$(NAME)-linux-armv7:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}" \
		"$(REPOSITORY)/$(NAME)-linux-arm64:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "$(REPOSITORY)/$(NAME):alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"
	# Manifest for $(REPOSITORY)/$(NAME):latest
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest create -a "$(REPOSITORY)/$(NAME):latest" \
		"$(REPOSITORY)/$(NAME)-linux-amd64:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}" \
		"$(REPOSITORY)/$(NAME)-linux-armv7:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}" \
		"$(REPOSITORY)/$(NAME)-linux-arm64:alpine-${ALPINE_VERSION}-pyinstaller-${PYINSTALLER_TAG}"
	DOCKER_CLI_EXPERIMENTAL=enabled docker manifest push "$(REPOSITORY)/$(NAME):latest"

