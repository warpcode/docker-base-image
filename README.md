![Github](https://img.shields.io/badge/Warpcode-Github-green?logo=github&style=for-the-badge) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/warpcode/docker-base-image/Build%20the%20image?style=for-the-badge)

## Introduction
This repository is to store a base installer for common utilities for docker containers.
It is a very minimal set of scripts to accomplish some common tasks.

## Tested Images
| IMAGE         | amd64   | arm64   | arm/v7 (armhf) |
|---------------|---------|---------|----------------|
| alpine:edge   | &check; | &check; | &check;        |
| alpine:latest | &check; | &check; | &check;        |
| centos:latest | &check; | &check; | &cross;        |
| debian:latest | &check; | &check; | &cross;        |
| ubuntu:18.04  | &check; | &check; | &check;        |
| ubuntu:20.04  | &check; | &check; | &check;        |
| ubuntu:latest | &check; | &check; | &check;        |

This script is tested using Docker's Buildx CLI plugin to test multiple architectures

## Usage
To install to the docker image, the following commands can be used.
Replace `{VERSION}` with the version you wish to install
```
ADD https://github.com/warpcode/docker-base-image/releases/download/v{VERSION}/release.tar.gz /tmp/release.tar.gz
RUN tar xzf /tmp/release.tar.gz -C / && /etc/warpcode/install.sh && rm -f /tmp/release.tar.gz
```

## Environment Variables
| ENV                    | DESCRIPTION                                                                      | DEFAULT       |
|------------------------|----------------------------------------------------------------------------------|---------------|
| CMD_AS_ROOT            | Run the CMD as root user                                                         | 0             |
| HOME_ROOT              | Set the home directory of the root user                                          | /root         |
| HOME_USER              | Set the home directory of the de-escalated user                                  | /home/app     |
| PUID                   | User ID of the internal non-root user                                            | 911           |
| PGID                   | Group ID of the internal non-root group                                          | 911           |
| PGID_LIST              | Group IDs list to pass to s6-setuidgid                                           |               |
| TZ                     | Set the timezone                                                                 | Europe/London |
| UMASK                  | Set the default umask                                                            | 0022          |
| URL_FETCH_IGNORE_CERTS | Ignore certs on the url-fetch script. This can be required for some base images. | 0


## Overriden S6 Variables
| ENV                          | DESCRIPTION                                | DEFAULT      |
|------------------------------|--------------------------------------------|--------------|
| S6_BEHAVIOUR_IF_STAGE2_FAILS | Changed to fail when our app service fails | 2            |
| S6_LOGGING                   | Changed when a CMD is detected             | 1 (With CMD) |


## Install only Environment Variables
| ENV                | DESCRIPTION                                             | DEFAULT       |
|--------------------|---------------------------------------------------------|---------------|
| EXTRA_PACKAGES     | Extra Packages to install regardless of package manager |               |
| EXTRA_APK_PACKAGES | Extra Packages to install only for APK (Alpine)         |               |
| EXTRA_APT_PACKAGES | Extra Packages to install only for APT (Debian/Ubuntu)  |               |

## Entrypoints
### /entrypoint
`/entrypoint` is the default entry point.


## Binaries

### finish-service
Only to be called by the root user. The main purpose is to be ran inside the `finish` script of a service that would bring down a container.

You can specify an exit code to force an exit code into `S6_STAGE2_EXITED` but this should only be called if you have
a main service.

Example usage
```
exec /usr/bin/finish-service -e 127 -s myapp
```

### run-app
A convenient wrapper around s6-applyuidgid and s6-setuidgid. When no uid or gid is supplied, the command is ran directly.

However, when a uid and gid is supplied, it will set the running user to the supplied uid and gid

Example usage
```
exec  /usr/bin/run-app -u 1000 -g 1000 -- id -u
```

### pkg-install
Included is a simple wrapper around the systems package manager to install packages

This script will also run `pkg-clean` automatically to clean up any package manager caches

For example, the below is how to install lastpass-cli on alpine images

```
RUN pkg_install lastpass-cli
```

### run-cmd
This adds a middle step for s6's /init when running commands via CMD.

When a CMD is detected, it is written to an environment variable which can be altered like any other environment variable.

The /init system will call run-cmd to handle whether to run the CMD as the root user or de-escalate priveleges

## S6 Overlay Documentation
* Make sure to read the [S6 overlay documentation].  It contains information
that can help building your image.  For example, the S6 overlay allows you to
easily add initialization scripts and services.

[S6 overlay documentation]: https://github.com/just-containers/s6-overlay/blob/master/README.md

[TimeZone]: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
