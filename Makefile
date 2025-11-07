.PHONY: help build build-no-cache load-kind install upgrade uninstall template lint test port-forward logs status history rollback clean

# Variables
IMAGE_NAME = devops-frontend
IMAGE_TAG = latest
CHART_NAME = frontend
RELEASE_NAME = frontend
NAMESPACE = frontend
KIND_CLUSTER = devops-cluster

help:
	@echo "Available commands:"
	@echo ""
	@echo "Docker commands:"
	@echo "  make build         - Build Docker image (with cache)"
	@echo "  make build-no-cache - Build Docker image (without cache)"
	@echo "  make load-kind     - Load image into Kind cluster"
	@echo ""
	@echo "Helm commands:"
	@echo "  make lint          - Lint Helm chart"
	@echo "  make template      - Show generated Kubernetes manifests"
	@echo "  make install       - Install chart to cluster"
	@echo "  make upgrade       - Upgrade existing release"
	@echo "  make uninstall     - Uninstall release from cluster"
	@echo "  make status        - Show release status"
	@echo "  make history       - Show release history"
	@echo "  make rollback      - Rollback to previous version"
	@echo "  make values        - Show values used in release"
	@echo ""
	@echo "Kubernetes commands:"
	@echo "  make port-forward  - Forward port 3000 to localhost"
	@echo "  make logs          - Show pod logs"
	@echo "  make test          - Test the deployment"
	@echo "  make describe-pod  - Describe frontend pod"
	@echo "  make shell         - Open shell in frontend pod"
	@echo ""
	@echo "Combined commands:"
	@echo "  make all           - Build, load and install"
	@echo "  make redeploy      - Rebuild, reload and upgrade"
	@echo "  make clean         - Clean up everything"

build:
	@echo "Building Docker image..."
	DOCKER_BUILDKIT=1 docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

build-no-cache:
	@echo "Building Docker image (no cache)..."
	DOCKER_BUILDKIT=1 docker build --no-cache -t $(IMAGE_NAME):$(IMAGE_TAG) .

load-kind:
	@echo "Loading image into Kind cluster..."
	kind load docker-image $(IMAGE_NAME):$(IMAGE_TAG) --name $(KIND_CLUSTER)

lint:
	@echo "Linting Helm chart..."
	helm lint chart/

template:
	@echo "Generating Kubernetes manifests..."
	helm template $(RELEASE_NAME) chart/

install:
	@echo "Installing Helm chart..."
	helm install $(RELEASE_NAME) chart/ \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--wait

upgrade:
	@echo "Upgrading Helm release..."
	helm upgrade $(RELEASE_NAME) chart/ \
		--namespace $(NAMESPACE) \
		--wait

uninstall:
	@echo "Uninstalling Helm release..."
	helm uninstall $(RELEASE_NAME) --namespace $(NAMESPACE)

status:
	@echo "Checking release status..."
	helm status $(RELEASE_NAME) --namespace $(NAMESPACE)

history:
	@echo "Showing release history..."
	helm history $(RELEASE_NAME) --namespace $(NAMESPACE)

rollback:
	@echo "Rolling back to previous version..."
	helm rollback $(RELEASE_NAME) --namespace $(NAMESPACE)

values:
	@echo "Showing values used in release..."
	helm get values $(RELEASE_NAME) --namespace $(NAMESPACE)

port-forward:
	@echo "Port forwarding to localhost:3000..."
	kubectl port-forward -n $(NAMESPACE) svc/$(RELEASE_NAME) 3000:80

logs:
	@echo "Showing pod logs..."
	kubectl logs -n $(NAMESPACE) -l app.kubernetes.io/name=$(CHART_NAME) -f --tail=100

test:
	@echo "Testing deployment..."
	@echo "\n=== Pods ==="
	@kubectl get pods -n $(NAMESPACE)
	@echo "\n=== Services ==="
	@kubectl get svc -n $(NAMESPACE)
	@echo "\n=== Deployment ==="
	@kubectl get deployment -n $(NAMESPACE)

describe-pod:
	@echo "Describing frontend pod..."
	kubectl describe pod -n $(NAMESPACE) -l app.kubernetes.io/name=$(CHART_NAME)

shell:
	@echo "Opening shell in frontend pod..."
	kubectl exec -it -n $(NAMESPACE) $$(kubectl get pod -n $(NAMESPACE) -l app.kubernetes.io/name=$(CHART_NAME) -o jsonpath='{.items[0].metadata.name}') -- /bin/sh

all: build load-kind install
	@echo "Frontend deployed successfully!"

redeploy: build load-kind upgrade
	@echo "Frontend redeployed successfully!"

clean: uninstall
	@echo "Cleaning up Docker images..."
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	@echo "Cleanup complete!"
