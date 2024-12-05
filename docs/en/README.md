# VPN Server with OpenVPN and WireGuard

## Project Description

This project deploys two VPN servers (OpenVPN and WireGuard) with user management UIs, using Docker and Traefik. Traffic is routed through domains with automatic SSL certificate generation.

### Features
- **OpenVPN** with a user-friendly admin interface (`admin.open.domain.com`).
- **WireGuard** with a web-based management UI (`admin.wg.domain.com`).
- Supported domains:
    - `vpn.open.domain.com` — OpenVPN access.
    - `vpn.wg.domain.com` — WireGuard access.
- Automatic SSL certificate management via Let's Encrypt.
- `Makefile` for streamlined management of containers.

---

## Instructions

### 1. Install Docker and Docker Compose
Ensure Docker and Docker Compose are installed:
```bash
docker --version
docker-compose --version
```

### 2. Project Setup

#### 2.1. Clone the repository:
```bash
git clone <repository_url>
cd <project_directory>
```

#### 2.2. Create the `.env.local` file:

```dotenv
BASE_DOMAIN=example.com
LETSENCRYPT_EMAIL=your-email@example.com
```

#### 2.3. Initialize VPN configurations:

```bash
make init-openvpn
```

#### 2.4. WireGuard configuration is automatically initialized on the first run.
   
### 3. Start Services

#### 3.1. Start all services:

```bash
make up
```

#### 3.2. Check logs:

```bash
make logs
```

#### 3.3. Add a user:

##### For OpenVPN:

```bash
make add-openvpn-client USERNAME=username
```

##### For WireGuard:

```bash
make add-wireguard-client USERNAME=username
```

### 4. Access

#### OpenVPN:

- Admin: https://admin.open.example.com
- VPN: `vpn.open.example.com`

#### WireGuard:

- Admin: https://admin.wg.example.com
- VPN: `vpn.wg.example.com`