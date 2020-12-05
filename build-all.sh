#!/usr/bin/env sh

BUILD_TYPE=""
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -b|--build)
            case $2 in
                dev|prod)
                    BUILD_TYPE=$2
                    ;;
                *)
                    echo "Unknown build. Must be dev or prod"
                    exit 1
                    ;;
            esac
            shift
            shift
            ;;
    esac
done

if [[ "$BUILD_TYPE" == "dev" ]]; then
    export DOCKER_CLI_EXPERIMENTAL=enabled

    echo "Setting up builder"
    docker buildx create --name=build-base-images --platform linux/amd64,linux/arm/v7,linux/arm64
    docker buildx use build-base-images
    docker buildx inspect --bootstrap
fi


set -e
for i in versions/*; do # Whitespace-safe but not recursive.
    bash build.sh -i $(basename "$i") -d -b "$BUILD_TYPE" $@
done
set +e

if [[ "$BUILD_TYPE" == "dev" ]] && [[ $DISABLE_BUILDER == false ]]; then
    echo "Destroying builder"
    docker buildx rm build-base-images
fi
