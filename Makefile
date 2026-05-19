PROJECT = Stella
CONTAINERS = stella stella_admin
BASE_COMPOSE = docker-compose.yml
DEV_COMPOSE = docker-compose.override.yml
PROD_COMPOSE = docker-compose.prod.yml
.DEFAULT_GOAL := help

# === STARTUP ===

start: install_network ## 🔐 Start the project in production mode
	@echo "🚀 Starting $(PROJECT) in \033[1mPRODUCTION\033[0m mode..."
	docker compose -f $(BASE_COMPOSE) -f $(PROD_COMPOSE) up -d

startall: install_network ## 🔨 Build & start in production
	@echo "🛠️  Building & starting $(PROJECT) in \033[1mPRODUCTION\033[0m mode..."
	docker compose -f $(BASE_COMPOSE) -f $(PROD_COMPOSE) up --build -d

start_dev: install_network ## 💻 Start the project in development mode (with override)
	@echo "💻 Starting $(PROJECT) in \033[1mDEVELOPMENT\033[0m mode..."
	docker compose -f $(BASE_COMPOSE) -f $(DEV_COMPOSE) up -d

startall_dev: install_network ## 🔧 Build & start in development
	@echo "🔧 Building & starting $(PROJECT) in \033[1mDEVELOPMENT\033[0m mode..."
	docker compose -f $(BASE_COMPOSE) -f $(DEV_COMPOSE) up --build -d

# === STOP & RESET ===

down: ## ⏹️ Stop the containers
	@echo "⏹️  Stopping containers..."
	docker compose stop $(CONTAINERS)

reset: down ## 🗑️ Remove the containers (excluding volumes)
	@echo "🗑️  Removing containers..."
	docker compose rm -f $(CONTAINERS)

reset-all: ## 💣 Full cleanup (containers + volumes + networks)
	@echo "💣 Full cleanup (containers + volumes + networks)..."
	docker compose -f $(BASE_COMPOSE) down -v --remove-orphans

# === TOOLS ===

check: ## ✅ Validate Compose configuration and local env file
	@if [ ! -f .env ]; then \
		echo "❌ .env file is missing"; \
		echo "   Create it with: cp .env.template .env"; \
		exit 1; \
	fi
	@echo "🔎 Validating Docker Compose configuration..."
	@docker compose -f $(BASE_COMPOSE) -f $(DEV_COMPOSE) config > /dev/null
	@echo "✅ Compose configuration is valid."

status: ## 📦 Show container status
	docker compose ps

logs: ## 📜 Show live logs
	docker compose logs -f

envcheck: ## 🔎 Check the current environment variables
	@if [ ! -f .env ]; then \
		echo "❌ .env file is missing"; \
	else \
		echo "🧾 Loaded environment variables:"; \
		sed -E '/^\s*#/d; /^\s*$$/d; s/^(([^=]*)(PASSWORD|SECRET|TOKEN|KEY)[^=]*)=.*/\1=****/' .env; \
	fi

install_network: ## 🌐 Create 'interservices' network if it doesn't exist
	@echo "🌐 Checking for 'interservices' network..."
	@if ! docker network inspect interservices > /dev/null 2>&1; then \
		echo "🔧 Creating 'interservices' network..."; \
		docker network create interservices; \
	else \
		echo "✅ 'interservices' network already exists."; \
	fi

# === HELP ===

help: ## 📖 Show this help
	@echo ""
	@echo "🎛️  \033[1;34m$(PROJECT) Makefile – Available Commands\033[0m"
	@echo ""
	@grep -E '^[a-zA-Z0-9_.-]+:.*?##' Makefile \
		| awk 'BEGIN {FS = ":.*?## "}; {printf " \033[33m%-18s\033[0m %s\n", $$1, $$2}'
	@echo ""

.PHONY: start startall start_dev startall_dev down reset reset-all check status logs envcheck install_network help
