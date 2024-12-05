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

# OpenVPN commands (Команды для OpenVPN)
init-openvpn: ## Initialize OpenVPN configuration (Инициализировать конфигурацию OpenVPN)
	@docker run --rm -v $(PWD)/vpn/openvpn:/etc/openvpn kylemanna/openvpn ovpn_genconfig -u udp://vpn.open.$(shell grep BASE_DOMAIN $(ENV_FILE) | cut -d '=' -f2)
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
