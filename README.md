![Github](https://img.shields.io/badge/Warpcode-Github-green?logo=github&style=for-the-badge) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/warpcode/docker-base-image/Build%20the%20image?style=for-the-badge)

## Introduction
This repository is to store a base installer for common utilities for docker containers.
It is a very minimal set of scripts to accomplish some common tasks.

## Supported Images
These scripts were tested on alpine, debian and ubuntu official images.

## Supported Architectures
* x86-64
* arm64
* armhf

This script is tested using Docker's Buildx CLI plugin to test multiple architectures

## Usage
To install to the docker image, the following commands can be used
Replace `{VERSION}` with the version you wish to install
```
ADD https://github.com/warpcode/docker-base-image/releases/download/v{VERSION}/release.tar.gz /tmp/release.tar.gz
RUN tar xzf /tmp/release.tar.gz -C / && /etc/warpcode/install.sh && rm -f /tmp/release.tar.gz
```

## Environment Variables
| ENV  | DESCRIPTION                             |
|------|-----------------------------------------|
| PUID | User ID of the internal non-root user   |
| PGID | Group ID of the internal non-root group |
| TZ   | Timezone. Default: Europe/London        |


## Entrypoints
### /entrypoint
`/entrypoint` is the default entry point.

### /entrypoint-user
`/entrypoint-user` is an entrypoint designed for applications you want to run as general user other than root.

## Binaries

### pkg_install
Included is a simple wrapper around the systems package manager to install packages

This script will also run `pkg_clean` automatically to clean up any package manager caches

For example, the below is how to install lastpass-cli on alpine images

```
RUN pkg_install lastpass-cli
```

