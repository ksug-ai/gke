#!/bin/bash
set -e

IMAGE_NAME="heyongkang/vulnerable-llm-app:v4"

echo "Building and pushing Docker image for linux/amd64..."
docker buildx build --platform linux/amd64 --push -t $IMAGE_NAME .

echo "Image ready: $IMAGE_NAME"
