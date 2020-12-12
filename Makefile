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
VERSIONS := $(addprefix build-test-,$(VERSION_FILES))
export DOCKER_CLI_EXPERIMENTAL

define build_tests_template =
    .PHONY: build-test-$(1)
    build-test-$(1): DOCKER_BASE_IMAGE = $$(shell source "versions/$(1)"; echo "$$$${DOCKER_BASE_IMAGE:-$${DOCKER_BASE_IMAGE_DEFAULT}}")
    build-test-$(1): DOCKER_DEST_IMAGE = $$(shell source "versions/$(1)"; echo "$$$${DOCKER_DEST_IMAGE:-$$(DOCKER_BASE_IMAGE)}")
    build-test-$(1): DOCKER_FILE = $$(shell source "versions/$(1)"; echo "$$$${DOCKER_FILE:-$$(DOCKER_FILE_DEFAULT)}")
    build-test-$(1): DOCKER_USER = $$(shell source "versions/$(1)"; echo "$$$${DOCKER_USER:-$$(DOCKER_USER_DEFAULT)}")
    build-test-$(1): build-test
endef
$(foreach cmpnt,$(VERSION_FILES),$(eval $(call build_tests_template,$(cmpnt))))

build-test: builder-setup build-docker-test builder-destroy

build-docker: builder-setup build-docker-load builder-destroy

build-docker-test:
	docker buildx build \
		--pull \
		-f "Dockerfile.$(DOCKER_FILE)" \
		-t "$(DOCKER_USER)/$(DOCKER_DEST_IMAGE)" \
		--platform="linux/amd64,linux/arm/v7,linux/arm64" \
		--build-arg BASE_IMAGE="$(DOCKER_BASE_IMAGE)" \
		.

build-docker-load:
	docker buildx build \
		--load \
		--pull \
		-f "Dockerfile.$(DOCKER_FILE)" \
		-t "$(DOCKER_USER)/$(DOCKER_DEST_IMAGE)" \
		--build-arg BASE_IMAGE="$(DOCKER_BASE_IMAGE)" \
		.

build-push:
	docker buildx build \
		--push \
		--pull \
		-f "Dockerfile.$(DOCKER_FILE)" \
		-t "$(DOCKER_USER)/$(DOCKER_DEST_IMAGE)" \
		--platform="linux/amd64,linux/arm/v7,linux/arm64" \
		--build-arg BASE_IMAGE="$(DOCKER_BASE_IMAGE)" \
		.

builder-setup:
	docker buildx create --name="$(BUILDER_NAME)" --platform="linux/amd64,linux/arm/v7,linux/arm64"
	docker buildx use $(BUILDER_NAME)
	docker buildx inspect --bootstrap

builder-destroy:
	docker buildx rm "$(BUILDER_NAME)"
