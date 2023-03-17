#!/bin/sh -l

# Change to .decontainer folder and calculate Dockerfile hash
cd ${GITHUB_WORKSPACE}/.devcontainer
IMG_NAME="ghcr.io/dafessor/devops-demo-img"
DOCKER_HASH=$(sha1sum Dockerfile 2>&1 || true)
# Get info on any existing image and try to match hashes
IMAGE_UP2DATE=$((docker inspect ${IMG_NAME} 2>&1 || true) | (grep -c ${DOCKER_HASH} || true))


# If hashes don't (or don exist), build and push image
if [ "${IMAGE_UP2DATE}" != "1" ]; then
    docker image rm "${IMG_NAME}" || true
    docker build -t "${IMG_NAME}":latest --label org.opencontainers.image.description=${DOCKER_HASH} .
    docker push "${IMG_NAME}"
fi

exit 0
