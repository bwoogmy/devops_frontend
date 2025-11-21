.PHONY: help build build-no-cache push load-kind install upgrade uninstall template lint test unit-test clean

# Variables
IMAGE_NAME = devops-frontend
IMAGE_TAG = latest
REGISTRY = ghcr.io/bwoogmy
CHART_NAME = frontend
RELEASE_NAME = frontend
NAMESPACE = frontend
KIND_CLUSTER = devops-cluster

help:
	@echo "Available commands:"
	@echo ""
	@echo "Docker commands:"
	@echo "  make build         - Build Docker image"
	@echo "  make push          - Push image to registry"
	@echo ""
	@echo "Test commands:"
	@echo "  make unit-test     - Run unit tests"
	@echo "  make lint          - Lint Helm chart"

build:
	@echo "Building Docker image..."
	DOCKER_BUILDKIT=1 docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

push:
	@echo "Pushing Docker image to registry..."
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

unit-test:
	@echo "Running unit tests..."
	npm test

lint:
	@echo "Linting Helm chart..."
	helm lint chart/

all: build push
	@echo "Frontend built and pushed successfully!"

clean:
	@echo "Cleaning up Docker images..."
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	docker rmi $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) || true
	@echo "Cleanup complete!"
