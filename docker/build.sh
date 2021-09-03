#!/bin/sh

echo "Setting docker daemon running on minikube to build image"
eval $(minikube -p minikube docker-env)

echo "Building docker image"
docker build -t litecoin .
