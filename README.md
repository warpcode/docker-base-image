![Github](https://img.shields.io/badge/Warpcode-Github-green?logo=github&style=for-the-badge) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/warpcode/docker-base-image/Build%20the%20image?style=for-the-badge)

## Introduction
This repository is to store a base installer for common utilities for docker containers.

## Supported Architectures
* x86-64
* arm64
* armhf

This script is tested using  Docker's Buildx CLI plugin to test multiple architectures

## Usage
You can simply add and run the script to you docker containers

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
