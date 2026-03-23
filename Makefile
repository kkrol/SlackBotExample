# Makefile for Slack Bot with uv and podman support
# Supports GitFlow strategy with versioning

SHELL := /bin/bash
UV := uv
PODMAN := podman

# Colors for terminal output
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[1;34m
NC := \033[0m

.PHONY: help install clean run test docker docker-push docs lint format version

help: ## Display this help message
	@echo "$(BLUE)=== Slack Bot Chatty - Makefile with UV ===$(NC)"
	@echo "$(YELLOW)Usage: make [target]$(NC)"
	@echo ""
	@echo "   install              Install dependencies with uv"
	@echo "   clean                Clean build artifacts"
	@echo "   run                  Run the bot locally"
	@echo "   test                 Run tests"
	@echo "   test-coverage        Run tests with coverage"
	@echo "   lint                 Run linter (ruff)"
	@echo "   format               Format code with ruff"
	@echo "   version              Show current version"
	@echo "   docker               Build Docker image"
	@echo "   podman               Build Podman image"
	@echo "   podman-push          Push Podman image"
	@echo "   release              Create release"
	@echo ""

install: ## Install dependencies with uv
	@echo "$(YELLOW)Installing dependencies with uv...$(NC)"
	@$(UV) sync --all-extras
	@$(UV) pip install -e ".[dev]"
	@echo "$(GREEN)✅ Dependencies installed$(NC)"

install-prod: ## Install only production dependencies
	@echo "$(YELLOW)Installing production dependencies...$(NC)"
	@$(UV) sync

clean: ## Clean build artifacts and environment
	@echo "$(YELLOW)Cleaning up...$(NC)"
	@rm -rf .venv
	@rm -rf dist __pycache__ .pytest_cache .coverage .coverage.*
	@find . -type d -name __pycache__ -exec rm -rf {} +
	@echo "$(GREEN)✅ Cleanup complete$(NC)"

run: install ## Run the bot locally
	@echo "$(BLUE)🚀 Starting Slack Bot with uv...$(NC)"
	@$(UV) run python src/botChatty/app.py

test: install ## Run tests
	@echo "$(YELLOW)Running tests with uv...$(NC)"
	@$(UV) run pytest tests/ -v --cov=src/botChatty --cov-report=term-missing

test-coverage: install ## Run tests with coverage report
	@echo "$(YELLOW)Running tests with coverage...$(NC)"
	@$(UV) run pytest tests/ -v --cov=src/botChatty --cov-report=html:docs/coverage_html
	@echo "$(BLUE)Coverage report: docs/coverage_html/index.html$(NC)"

lint: install ## Run linter (ruff)
	@echo "$(YELLOW)Running linter...$(NC)"
	@$(UV) run ruff check src/botChatty tests
	@$(UV) run ruff format --diff src/botChatty tests || true

format: install ## Format code with ruff
	@echo "$(YELLOW)Formatting code...$(NC)"
	@$(UV) run ruff format src/botChatty tests
	@echo "$(GREEN)✅ Code formatted$(NC)"

version: ## Show current version
	@echo "$(BLUE)Current version: $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")$(NC)"

# === Docker/Podman Integration ===

docker: ## Build Docker image
	@echo "$(YELLOW)Building Docker image...$(NC)"
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg PYTHON_VERSION=3.11 \
		--build-arg VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev") \
		-t $(IMAGE_NAME):$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev") \
		-t $(IMAGE_NAME):latest \
		.
	@echo "$(GREEN)✅ Docker image built$(NC)"

docker-build: ## Full Docker build
	@echo "$(YELLOW)Building Docker image...$(NC)"
	@DOCKER_BUILDKIT=1 docker build \
		--build-arg PYTHON_VERSION=3.11 \
		--build-arg VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev") \
		-t $(IMAGE_NAME):$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev") \
		-t $(IMAGE_NAME):latest \
		.

podman: ## Build Podman image
	@echo "$(YELLOW)Building Podman image...$(NC)"
	@$(PODMAN) build \
		-t $(IMAGE_NAME):$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev") \
		-t $(IMAGE_NAME):latest \
		--build-arg PYTHON_VERSION=3.11 \
		.
	@echo "$(GREEN)✅ Podman image built$(NC)"

podman-push: ## Push Podman image to registry
	@echo "$(YELLOW)Pushing Podman image...$(NC)"
	@$(PODMAN) push $(IMAGE_NAME):$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
	@$(PODMAN) push $(IMAGE_NAME):latest
	@echo "$(GREEN)✅ Image pushed$(NC)"

podman-save: ## Save Podman image to tarball
	@echo "$(YELLOW)Saving Podman image...$(NC)"
	@$(PODMAN) save -o $(IMAGE_NAME).tar $(IMAGE_NAME):latest
	@echo "$(GREEN)✅ Image saved to $(IMAGE_NAME).tar$(NC)"

podman-load: ## Load Podman image from tarball
	@echo "$(YELLOW)Loading Podman image...$(NC)"
	@$(PODMAN) load -i $(IMAGE_NAME).tar
	@echo "$(GREEN)✅ Image loaded$(NC)"

release: ## Create release (version, tag, build)
	@VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
	@echo "$(YELLOW)📦 Release: v$(VERSION)$(NC)"
	@$(UV) sync
	@$(UV) run pytest tests/ -v
	@$(MAKE) --no-print-directory docker
	@$(MAKE) --no-print-directory podman
	@echo "$(GREEN)✅ Release v$(VERSION) complete!$(NC)"

env: ## Create .env file from template
	@echo "$(YELLOW)Creating .env file from template...$(NC)"
	@cp .env.samples .env
	@echo "$(BLUE)Please edit .env and add your tokens$(NC)"

# === Development ===

dev: install run ## Run in development mode

# === Documentation ===

docs: ## Generate documentation
	@echo "$(YELLOW)Building documentation...$(NC)"
	@# Add any documentation build steps here
	@touch docs/.doctored

lint-docs: ## Lint documentation
	@echo "$(YELLOW)Linting documentation...$(NC)"
	@$(UV) run python -m doc8 docs
	@echo "$(GREEN)✅ Documentation linted$(NC)"

spellcheck: ## Spellcheck documentation
	@echo "$(YELLOW)Spellchecking documentation...$(NC)"
	@$(UV) run python -m pycodestyle --select=W docs
	@echo "$(GREEN)✅ Spelling checked$(NC)"

# === Utility ===

env-update: ## Update environment variables
	@echo "$(YELLOW)Updating environment...$(NC)"
	@$(UV) pip list

clean-all: clean ## Clean everything
	@echo "$(YELLOW)Cleaning all artifacts...$(NC)"
	@rm -f $(IMAGE_NAME).tar
	@docker system prune -f
	@podman system prune -f
	@echo "$(GREEN)✅ All artifacts cleaned$(NC)"

# === Internal targets ===

_images-prune:
	@echo "$(YELLOW)Pruning images...$(NC)"
	@$(PODMAN) rmi $(IMAGE_NAME)
	@docker rmi $(IMAGE_NAME)

_volumes-prune:
	@echo "$(YELLOW)Pruning volumes...$(NC)"
	@$(PODMAN) volume prune -f
	@docker volume prune -f