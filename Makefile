APP_VERSION ?= $(shell git describe --tags --always --abbrev=0)

ifneq ($(shell which docker-compose 2>/dev/null),)
    DOCKER_COMPOSE := docker-compose
else
    DOCKER_COMPOSE := docker compose
endif

# Target container registry depends on the environment
ifeq ($(ENVIRONMENT),dev)
	REGISTRY ?= airmsdevappcr.azurecr.io
	DOCKER_CONTENT_TRUST=0
else
	REGISTRY ?= airmsdevopscr.azurecr.io
	DOCKER_CONTENT_TRUST=1
endif

DOCKER_IMAGE_PREFIX=$(REGISTRY)/open-webui
DOCKER_IMAGE=$(DOCKER_IMAGE_PREFIX)-d4l

install:
	$(DOCKER_COMPOSE) up -d

remove:
	@chmod +x confirm_remove.sh
	@./confirm_remove.sh

start:
	$(DOCKER_COMPOSE) start
startAndBuild:
	$(DOCKER_COMPOSE) up -d --build

stop:
	$(DOCKER_COMPOSE) stop

update:
	# Calls the LLM update script
	chmod +x update_ollama_models.sh
	@./update_ollama_models.sh
	@git pull
	$(DOCKER_COMPOSE) down
	# Make sure the ollama-webui container is stopped before rebuilding
	@docker stop open-webui || true
	$(DOCKER_COMPOSE) up --build -d
	$(DOCKER_COMPOSE) start

######
# Makefile Additions
######
.PHONY: docker-database-delete
docker-database-delete: ## Delete database in Docker
	-docker rm -f open-webui-postgres

.PHONY: docker-database ddb
docker-database ddb: docker-database-delete ## Run database in Docker
	docker run --name open-webui-postgres -d \
		-e POSTGRES_DB=open-webui \
		-e POSTGRES_USER=open-webui \
		-e POSTGRES_PASSWORD=postgres \
		-p 5555:5432 postgres
	@until docker container exec -t open-webui-postgres pg_isready; do \
		>&2 echo "Postgres is unavailable - waiting for it... 😴"; \
		sleep 1; \
	done

.PHONY: docker-build
docker-build db:
	@BUILDX_DRIVER=$$(docker buildx inspect default --format '{{.Driver}}'); \
	if [ "$$BUILDX_DRIVER" = "docker-container" ]; then \
		CACHE_ARGS="--cache-to type=gha,mode=max --cache-from type=gha"; \
	else \
		CACHE_ARGS=""; \
	fi; \
	docker buildx build $$CACHE_ARGS \
		--build-arg BUILD_SHA=$(APP_VERSION) \
		-t $(DOCKER_IMAGE):$(APP_VERSION) \
		-f Dockerfile \
		--load \
		.

.PHONY: docker-push
docker-push:        ## Push Docker image to registry
	DOCKER_CONTENT_TRUST=$(DOCKER_CONTENT_TRUST) docker push $(DOCKER_IMAGE):$(APP_VERSION)
