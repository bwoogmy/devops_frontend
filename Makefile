.PHONY: help build push unit-test lint package-chart push-chart clean all

# Variables
IMAGE_NAME = devops-frontend
IMAGE_TAG ?= latest
REGISTRY = ghcr.io/bwoogmy
CHART_NAME = devops-frontend

help:
	@echo "Available commands:"
	@echo ""
	@echo "Docker commands:"
	@echo "  make build              - Build Docker image"
	@echo "  make push               - Push image to registry"
	@echo ""
	@echo "Helm commands:"
	@echo "  make lint               - Lint Helm chart"
	@echo "  make package-chart      - Package Helm chart"
	@echo "  make push-chart         - Push Helm chart to OCI registry"
	@echo ""
	@echo "Test commands:"
	@echo "  make unit-test          - Run unit tests"

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

package-chart:
	@echo "Packaging Helm chart with version $(IMAGE_TAG)..."
	@sed -i 's/^version:.*/version: $(IMAGE_TAG)/' chart/Chart.yaml
	@sed -i 's/^appVersion:.*/appVersion: "$(IMAGE_TAG)"/' chart/Chart.yaml
	helm package chart/ --destination .helm-packages/

push-chart:
	@echo "Pushing Helm chart to OCI registry..."
	helm push .helm-packages/$(CHART_NAME)-$(IMAGE_TAG).tgz oci://$(REGISTRY)/helm

clean:
	@echo "Cleaning up..."
	rm -rf .helm-packages/
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	docker rmi $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) || true
	@echo "Cleanup complete!"

all: build push package-chart push-chart
	@echo "Frontend built and pushed successfully!"
