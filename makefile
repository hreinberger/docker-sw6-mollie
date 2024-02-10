.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ----------------------------------------------------------------------------------------------------------------

dev: ## Builds the image and starts the container for development
	docker pull dockware/play:latest
	docker-compose build --no-cache
	docker-compose up -d
	sleep 10
	open http://localhost/admin
	open http://localhost

# ----------------------------------------------------------------------------------------------------------------

build: ## Builds the image
	docker pull dockware/play:latest
	DOCKER_BUILDKIT=1 docker build --no-cache -t boxblinkracer/mollie-sw6:latest docker/.

push: ## Pushes the image
	docker pull dockware/play:latest
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t boxblinkracer/mollie-sw6:latest --push docker/.
