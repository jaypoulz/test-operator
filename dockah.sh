#!/bin/bash

### Prerequisites ###
# Install go1.17

## For docker
# Install latest version of docker
# Start docker
# Set up docker buildx driver with `$ docker buildx create --use`

# Reset the working directory
#rm -rf test-operator-sdk

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

### Docker BuildX Build/Push ###
REPO=quay.io/jpoulin/test-operator:v1-dockah
docker buildx build --push --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x --tag $REPO .
### End BuildX ###

### Basic Build/Push ###
# make docker-build docker-push IMG="quay.io/jpoulin/test-operator:v0.0.1"
### End Basic ###

popd
