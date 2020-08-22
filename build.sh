#!/usr/bin/env sh

BUILD_S6=false
PUSH_TO_DOCKER=false
DISABLE_BUILDER=false
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
        -s6|--s6)
            BUILD_S6=true
            shift
            ;;
        -i|--image)
            IMAGE_VERSION=$2
            shift
            shift
            ;;
        -l|docker-load)
            # Only for dev and will remove multiarch building
            PUSH_TO_DOCKER=true
            shift
            ;;
        -d|--disable-builder)
            # Only for dev and will remove multiarch building
            DISABLE_BUILDER=true
            shift
            ;;
        *)    # unknown option
            echo "Unknown option: $key"
            exit 1;
            ;;
    esac
done

if [[ -z $IMAGE_VERSION ]]; then
    echo "no image has been specified"
    exit 1;
fi

if [[ ! -f "versions/$IMAGE_VERSION" ]]; then
    echo "no image file does not exist"
    exit 1;
fi

if [[ -z $BUILD_TYPE ]]; then
    echo "build has not been specified"
    exit 1;
fi

export DOCKER_CLI_EXPERIMENTAL=enabled

if [[ "$BUILD_TYPE" == "dev" ]] && [[ $DISABLE_BUILDER == false ]]; then
    echo "Setting up builder"
    docker buildx create --name=build-base-images --platform linux/amd64,linux/arm/v7,linux/arm64
    docker buildx use build-base-images
    docker buildx inspect --bootstrap
fi

SUCCESSFUL=true

# Clear vars
ARCHITECTURES=
DOCKERFILE=
BASE_IMAGE=
BASE_TAG=
DEST_IMAGE=
DEST_TAG=

# Clear s6 vars
ARCHITECTURES_S6=
DOCKERFILE_S6=
BASE_IMAGE_S6=
BASE_TAG_S6=
DEST_IMAGE_S6=
DEST_TAG_S6=

source "versions/$IMAGE_VERSION"

if [[ "$DOCKERFILE" == "" ]]; then
    echo "Skipping $i. No dockerfile supplied"
    continue;
fi

if [[ $BUILD_S6 == true ]]; then
    if [[ "$ARCHITECTURES_S6" != "" ]]; then
        ARCHITECTURES=$ARCHITECTURES_S6
    fi

    if [[ "$BASE_IMAGE_S6" != "" ]]; then
        BASE_IMAGE=$BASE_IMAGE_S6
    else
        # If no s6 base image is specified, assume we're using a compiled version
        # we pushed
        BASE_IMAGE="warpcode/${BASE_IMAGE#*/}-s6"
    fi

    if [[ "$BASE_TAG_S6" != "" ]]; then
        BASE_TAG=$BASE_TAG_S6
    fi

    if [[ "$BASE_IMAGE" == "" ]] || [[ "$BASE_TAG" == "" ]]; then
        echo "Skipping $i. No S6 base image or tag supplied"
        continue;
    fi

    if [[ "$DOCKERFILE_S6" != "" ]]; then
        DOCKERFILE=$DOCKERFILE_S6
    else
        DOCKERFILE="${DOCKERFILE}-s6"
    fi

    if [[ "$DEST_IMAGE_S6" != "" ]]; then
        DEST_IMAGE=$DEST_IMAGE_S6
    fi

    if [[ "$DEST_TAG_S6" != "" ]]; then
        DEST_TAG=$DEST_TAG_S6
    fi
fi

if [[ "$BASE_IMAGE" == "" ]] || [[ "$BASE_TAG" == "" ]]; then
    echo "Skipping $i. No base image or tag supplied"
    continue;
fi

if [[ "$DEST_IMAGE" == "" ]]; then
    DEST_IMAGE="warpcode/${BASE_IMAGE#*/}"
fi

if [[ "$DEST_TAG" == "" ]]; then
    DEST_TAG=$BASE_TAG
fi

PUSH_IMAGE=
if [[ "$BUILD_TYPE" == "prod" ]]; then
    PUSH_IMAGE="--push"
fi

ARCHITECTURES=${ARCHITECTURES:-linux/amd64,linux/arm,linux/arm64}
if [[ "$BUILD_TYPE" == "dev" ]] && [[ $PUSH_TO_DOCKER == true ]]; then
    PUSH_IMAGE="--load"
    ARCHITECTURES=
fi

PLATFORM=
if [[ "$ARCHITECTURES" != "" ]]; then
    PLATFORM="--platform $ARCHITECTURES"
fi

set -x
docker buildx build \
    $PUSH_IMAGE \
    --pull \
    -f "Dockerfile.${DOCKERFILE}" \
    -t "$DEST_IMAGE:$DEST_TAG" \
    $PLATFORM \
    --build-arg BASE_IMAGE="$BASE_IMAGE" \
    --build-arg BASE_TAG="$BASE_TAG" \
    .
set +x

if [[ "$BUILD_TYPE" == "dev" ]] && [[ $DISABLE_BUILDER == false ]]; then
    echo "Destroying builder"
    docker buildx rm build-base-images
fi

if [[ $SUCCESSFUL == false ]]; then
    exit 1;
fi

exit 0;
