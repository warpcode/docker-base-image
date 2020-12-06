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


## Entrypoints
### /init
`/init` is the default entry point and is designed for service containers.

### /init-single
`/init-single` is an entrypoint designed for single run applications.

Rather than using s6's de-escalation binaries where I had issues with the user environment not being set up correctly,
it will use su-exec on systems where it's installable (ie alpine) or gosu.

This is essentially a wrapper around `/init` and if no arguments are passed, it will run bash in the default user environment.

If creating a container and you always want to force a command, setup the entrypoint of the container like so

```
ENTRYPOINT ["/init-single", "application"]
```

This will allow `CMD` to just pass arguments to your specified application.
