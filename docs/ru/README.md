# VPN Сервер с OpenVPN и WireGuard

## Описание проекта

Этот проект позволяет развернуть два VPN-сервера (OpenVPN и WireGuard) с UI для управления пользователями, используя Docker и Traefik. Трафик маршрутизируется через домены, с автоматической генерацией SSL-сертификатов.

### Функциональность
- **OpenVPN** с пользовательским интерфейсом для управления (`admin.open.domain.com`).
- **WireGuard** с UI для управления (`admin.wg.domain.com`).
- Поддержка доменов:
  - `vpn.open.domain.com` — доступ к OpenVPN.
  - `vpn.wg.domain.com` — доступ к WireGuard.
- Автоматическое управление SSL через Let's Encrypt.
- Использование `Makefile` для удобства работы с контейнерами.

---

## Инструкции

### 1. Установка Docker и Docker Compose
Убедитесь, что Docker и Docker Compose установлены:
```bash
docker --version
docker-compose --version
```

### 2. Настройка проекта

#### 2.1. Клонируйте репозиторий:
```bash
git clone <repository_url>
cd <project_directory>
```

#### 2.2. Создайте `.env.local` файл:
- Этот файл содержит домен и email для генерации SSL-сертификата и других настроек.
- Создайте файл с помощью следующей команды:
  ```bash
  make generate-env domain=example.com email=your-email@example.com
  ```
  Это создаст файл .env.local с переданными значениями домена и email. Команда также выполнит валидацию формата домена и email.

#### 2.3. Инициализируйте конфигурации VPN:

```bash
make init-openvpn
```

#### 2.4. Настройте WireGuard (при первом запуске конфигурация создаётся автоматически).

### 3. Запуск серверов

#### 3.1. Поднимите сервисы:

```bash
make up
```

#### 3.2. Проверьте логи:

```bash
make logs
```

#### 3.3. Добавьте пользователя:

##### Для OpenVPN:

```bash
make add-openvpn-client USERNAME=username
```

##### Для WireGuard:

```bash
make add-wireguard-client USERNAME=username
```

### 4. Доступ

#### OpenVPN:

- Админка: https://admin.open.example.com
- VPN: `vpn.open.example.com`

#### WireGuard:

- Админка: https://admin.wg.example.com
- VPN: `vpn.wg.example.com`
