#!/bin/sh -l

if [ ! $# -eq 1 ]; then
    exit 1
fi

GITHUB_TOKEN=$1

# Constants
IMG_NAME="ghcr.io/dafessor/devops-demo/devops-demo-img:latest"
IMG_NAME_URL_ENC="devops-demo%2Fdevops-demo-img"

# Change to .decontainer folder and calculate Dockerfile hash
cd "${GITHUB_WORKSPACE}"/.devcontainer || exit 1
DOCKER_HASH=$(sha1sum Dockerfile 2>&1 || true)

# Get info on any existing image and try to match hashes
IMG_UP2DATE=$(curl -s -L -H "Accept: application/vnd.github+json" \
                   -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                   -H "X-GitHub-Api-Version: 2022-11-28" \
                   "https://api.github.com/user/packages/container/${IMG_NAME_URL_ENC}/versions" | grep -c "${DOCKER_HASH}")

# If hashes don't (or don exist), build and push image
if [ "${IMG_UP2DATE}" -lt  1 ]; then
    echo "Rebuilding image, deleting any old stuff ...."
    docker image rm "${IMG_NAME}" || true
    echo "Doing the actual build ...."
    docker build -t "${IMG_NAME}" --label org.opencontainers.image.description="${DOCKER_HASH}" .
    echo "Pushing new image ...."
    docker push "${IMG_NAME}"
else
    echo "Image up to date, nothing to do ...."
fi

exit 0
