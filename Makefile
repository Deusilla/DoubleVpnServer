# Variables (Переменные)
ENV_FILE=.env.local
DOCKER_COMPOSE=docker-compose

.PHONY: help
help: ## Display available commands (Показать список доступных команд)
	@echo "Available commands (Доступные команды):"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Basic commands (Основные команды)
up: ## Start all services (Запустить все сервисы)
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) up -d

down: ## Stop and remove containers (Остановить и удалить контейнеры)
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) down

logs: ## View logs (Просмотр логов)
	@$(DOCKER_COMPOSE) --env-file $(ENV_FILE) logs -f

restart: ## Restart all services (Перезапустить все сервисы)
	@$(MAKE) down
	@$(MAKE) up

# Generate .env.local file (Генерация файла .env.local)
generate-env: ## Generate a .env.local file with domain and email (Создать файл .env.local с доменом и email)
ifndef domain
	$(error domain is not set. Use domain=example.com (domain не указан. Используйте domain=example.com))
endif
ifndef email
	$(error email is not set. Use email=your-email@example.com (email не указан. Используйте email=your-email@example.com))
endif
	@if ! echo "$(domain)" | grep -Eq '^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$$'; then \
		echo "Invalid domain format: $(domain). Use a valid domain, e.g., example.com (Некорректный формат домена: $(domain). Используйте корректный домен, например, example.com)"; \
		exit 1; \
	fi
	@if ! echo "$(email)" | grep -Eq '^[^@]+@[^@]+\.[a-zA-Z]{2,}$$'; then \
		echo "Invalid email format: $(email). Use a valid email, e.g., your-email@example.com (Некорректный формат email: $(email). Используйте корректный email, например, your-email@example.com)"; \
		exit 1; \
	fi
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "DOMAIN=$(domain)" > $(ENV_FILE); \
		echo "LETSENCRYPT_EMAIL=$(email)" >> $(ENV_FILE); \
		echo ".env.local created successfully (Файл .env.local успешно создан)"; \
	else \
		echo ".env.local already exists. Please edit it manually if needed (Файл .env.local уже существует. Измените его вручную, если нужно)"; \
	fi

# OpenVPN commands (Команды для OpenVPN)
init-openvpn: ## Initialize OpenVPN configuration (Инициализировать конфигурацию OpenVPN)
	@docker run --rm -v $(PWD)/vpn/openvpn:/etc/openvpn kylemanna/openvpn ovpn_genconfig -u udp://vpn.open.$(shell grep DOMAIN $(ENV_FILE) | cut -d '=' -f2)
	@docker run --rm -v $(PWD)/vpn/openvpn:/etc/openvpn -it kylemanna/openvpn ovpn_initpki

add-openvpn-client: ## Add a new OpenVPN client (Добавить нового клиента OpenVPN)
ifndef USERNAME
	$(error USERNAME is not set. Use USERNAME=username (USERNAME не указан. Используйте USERNAME=username))
endif
	@docker exec -it openvpn-server easyrsa build-client-full $(USERNAME) nopass
	@docker exec -it openvpn-server ovpn_getclient $(USERNAME) > $(USERNAME).ovpn

# WireGuard commands (Команды для WireGuard)
add-wireguard-client: ## Add a new WireGuard client (Добавить нового клиента WireGuard)
ifndef USERNAME
	$(error USERNAME is not set. Use USERNAME=username (USERNAME не указан. Используйте USERNAME=username))
endif
	@docker exec -it wireguard-server /app/wireguard.sh addclient $(USERNAME)

# Cleanup (Очистка)
clean: ## Remove all project data (Удалить все данные проекта)
	@$(DOCKER_COMPOSE) down -v
	@rm -rf vpn
	@echo "All data has been removed (Все данные удалены)."
