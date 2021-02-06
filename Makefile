SHELL := /bin/bash

BUILDER_NAME := warpcode-base-images
DOCKER_FILE := default
DOCKER_FILE_DEFAULT := $(DOCKER_FILE)
DOCKER_USER := warpcode
DOCKER_USER_DEFAULT := $(DOCKER_USER)
DOCKER_BASE_IMAGE := alpine:latest
DOCKER_BASE_IMAGE_DEFAULT := $(DOCKER_BASE_IMAGE)
DOCKER_DEST_IMAGE := alpine:latest
DOCKER_CLI_EXPERIMENTAL := enabled
VERSION_FILES := $(notdir $(wildcard versions/*))
export DOCKER_CLI_EXPERIMENTAL

.PHONY: release build-test-all $(addprefix build-test-,$(VERSION_FILES)) $(addprefix build-docker-load-,$(VERSION_FILES))

build-test-all: $(addprefix build-test-,$(VERSION_FILES))
build-local-test-all: builder-setup build-test-all builder-destroy

define build_tests_template =
    .PHONY: build-local-test-$(1) build-test-$(1) build-docker-load-$(1)

    build-local-test-$(1): builder-setup build-test-$(1) builder-destroy
    build-local-docker-$(1): builder-setup build-docker-load-$(1) builder-destroy

    build-local-docker-run-$(1): build-local-docker-$(1)
	    @source "versions/$(1)"; \
		DOCKER_BASE_IMAGE=$$$${DOCKER_BASE_IMAGE}; \
		DOCKER_DEST_IMAGE=$$$${DOCKER_DEST_IMAGE:-$$$${DOCKER_BASE_IMAGE}}; \
		DOCKER_FILE=$$$${DOCKER_FILE:-$$(DOCKER_FILE)}; \
		DOCKER_USER=$$$${DOCKER_USER:-$$(DOCKER_USER)}; \
		docker run \
            --name "docker-base-image-$(1)-$$$${RANDOM}" \
            --rm \
            -it \
            -e DEBUG_CONTAINER=1 \
            -e PUID=$(shell id -u) \
            -e PGID=$(shell id -g) \
            -e TZ=UTC \
            -e UMASK=0002 \
            "$$$${DOCKER_USER}/$$$${DOCKER_DEST_IMAGE}" \
            /bin/bash

    build-test-$(1): release
	    @source "versions/$(1)"; \
		DOCKER_BASE_IMAGE=$$$${DOCKER_BASE_IMAGE}; \
		DOCKER_DEST_IMAGE=$$$${DOCKER_DEST_IMAGE:-$$$${DOCKER_BASE_IMAGE}}; \
		DOCKER_FILE=$$$${DOCKER_FILE:-$$(DOCKER_FILE)}; \
		DOCKER_USER=$$$${DOCKER_USER:-$$(DOCKER_USER)}; \
		docker buildx build \
            --pull \
            -f "Dockerfile.$$$${DOCKER_FILE}" \
            -t "$$$${DOCKER_USER}/$$$${DOCKER_DEST_IMAGE}" \
            --platform="linux/amd64,linux/arm/v7,linux/arm64" \
            --build-arg BASE_IMAGE="$$$${DOCKER_BASE_IMAGE}" \
            .

    build-docker-load-$(1): release
	    @source "versions/$(1)"; \
		DOCKER_BASE_IMAGE=$$$${DOCKER_BASE_IMAGE}; \
		DOCKER_DEST_IMAGE=$$$${DOCKER_DEST_IMAGE:-$$$${DOCKER_BASE_IMAGE}}; \
		DOCKER_FILE=$$$${DOCKER_FILE:-$$(DOCKER_FILE)}; \
		DOCKER_USER=$$$${DOCKER_USER:-$$(DOCKER_USER)}; \
		docker buildx build \
			--load \
            --pull \
            -f "Dockerfile.$$$${DOCKER_FILE}" \
            -t "$$$${DOCKER_USER}/$$$${DOCKER_DEST_IMAGE}" \
            --build-arg BASE_IMAGE="$$$${DOCKER_BASE_IMAGE}" \
            .
endef
$(foreach cmpnt,$(VERSION_FILES),$(eval $(call build_tests_template,$(cmpnt))))

builder-setup:
	docker buildx create --name="$(BUILDER_NAME)" --platform="linux/amd64,linux/arm/v7,linux/arm64"
	docker buildx use $(BUILDER_NAME)
	docker buildx inspect --bootstrap

builder-destroy:
	docker buildx rm "$(BUILDER_NAME)" || exit 0

release:
	tar -c -C rootfs/ -zvf release.tar.gz --owner=0 --group=0 .

clean: builder-destroy
	test -e release.tar.gz && rm release.tar.gz || exit 0
