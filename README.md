![Github](https://img.shields.io/badge/Warpcode-Github-green?logo=github&style=for-the-badge) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/warpcode/docker-base-image/Build%20the%20image?style=for-the-badge)

## Introduction
These image are intended to be base images with common scripts as a base for my other docker images.

## Supported Architectures
* x86-64
* arm64
* armhf

These images use Docker's Buildx CLI plugin to upload mult-architecture tags

## Version Tags
This repository will mostly support the `latest` tags of supported base images.
In some instances, other major version tags will be supported but it depends on the base image.

## Usage
The image supplied is a base OS images with both [s6-overlay](https://github.com/just-containers/s6-overlay) and su-exec installed.
There are also additional scripts installed to handle:
* Changing the user ID and group ID of the provided default user.
* Changing the timezone within the image

## Environment Variables
| ENV  | DESCRIPTION                             |
|------|-----------------------------------------|
| PUID | User ID of the internal non-root user   |
| PGID | Group ID of the internal non-root group |
| TZ   | Timezone. Default: Europe/London        |

