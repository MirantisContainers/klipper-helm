TARGETS := $(shell ls scripts)

VERSION ?= latest

IMAGE_REPO ?= ghcr.io/mirantiscontainers
IMAGE_TAG_BASE ?= $(IMAGE_REPO)/klipper-helm

# Image URL to use all building/pushing image targets
IMG ?= $(IMAGE_TAG_BASE):$(VERSION)
COMMIT ?= $(shell git rev-parse --short=7 HEAD)

.dapper:
	@echo Downloading dapper
	@curl -sL https://releases.rancher.com/dapper/latest/dapper-`uname -s`-`uname -m` > .dapper.tmp
	@@chmod +x .dapper.tmp
	@./.dapper.tmp -v
	@mv .dapper.tmp .dapper

$(TARGETS): .dapper
	./.dapper $@

trash: .dapper
	./.dapper -m bind trash

trash-keep: .dapper
	./.dapper -m bind trash -k

docker-build: ci
	docker tag rancher/klipper-helm:$(COMMIT)-amd64 $(IMG)


deps: trash

.DEFAULT_GOAL := ci

.PHONY: $(TARGETS)
