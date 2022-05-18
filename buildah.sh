#!/bin/bash

### Prerequisites ###
# Install go1.17

## For podman
# Install podman, buildah, and qemu-user-static

# Reset the working directory
# rm -rf test-operator-sdk

# Make a dummy APP
# mkdir test-operator-sdk
pushd test-operator-sdk
# operator-sdk init --domain jaypoulz.me --repo github.com/jaypoulz/test-operator-sdk

# Make a dummy API
#operator-sdk create api --group test --version v1 --kind SpamTest --controller --resource

# Set up Kube for testing
# minikube start
# alias kubectl="minikube kubectl --"

# Install API on Kube
# make install run

export MANIFEST_NAME="multiarch-test"

### Buildah Build/Push ###
# Set the required variables
export BUILD_PATH="."
export REGISTRY="quay.io"
export USER="jpoulin"
export IMAGE_NAME="test-operator"
export IMAGE_TAG="v1-buildah"

# Create a multi-architecture manifest
buildah manifest rm ${MANIFEST_NAME}
buildah manifest create ${MANIFEST_NAME}

for a in amd64 arm64 ppc64le s390x; do \
  # Build your amd64 architecture container
  buildah bud \
      --tag "${REGISTRY}/${USER}/${IMAGE_NAME}:${IMAGE_TAG}" \
      --manifest ${MANIFEST_NAME} \
      --arch $a \
      --build-arg TARGETOS=linux \
      --build-arg TARGETARCH=$a \
      ${BUILD_PATH}
done

# Push the full manifest, with both CPU Architectures
buildah manifest push --all \
    ${MANIFEST_NAME} \
    "docker://${REGISTRY}/${USER}/${IMAGE_NAME}:${IMAGE_TAG}"
### End Buildah ###

popd
