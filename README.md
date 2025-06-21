# 🐳 Stella – Dockerized MariaDB + Adminer Stack

This project provides a lightweight Docker-based setup for local or production use of a MariaDB database with Adminer as a web interface.

---

## 🚀 Quick Start

### 📦 Requirements

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose v2+](https://docs.docker.com/compose/)
- `make` installed (Linux/macOS/WSL)

---

### 🔧 Setup

1. Copy the environment file:

   ```bash
   cp .env.example .env
````

2. (Optional) Edit `.env` to define your `MARIADB_ROOT_PASSWORD`.

3. Create the shared Docker network if not already existing:

   ```bash
   make install_network
   ```

---

### 💻 Run the Stack

#### Development Mode (ports exposed)

```bash
make start_dev         # Start without rebuilding
make startall_dev      # Rebuild and start
```

Adminer will be available at: [http://localhost:8080](http://localhost:8080)

#### Production Mode (no ports exposed)

```bash
make start             # Start without rebuilding
make startall          # Rebuild and start
```

---

## 🛠️ Management Commands

```bash
make status            # Show container status
make logs              # View logs
make down              # Stop containers
make reset             # Stop and remove containers
make reset-all         # Full cleanup (containers + volumes + networks)
make envcheck          # Display loaded .env variables
```

---

## 🌐 Network

All services are connected to a shared external Docker network:

```bash
docker network create interservices
```

This allows seamless communication across services and projects.

---

## 📁 Folder Structure

```
.
├── docker-compose.yml
├── docker-compose.override.yml     # dev-specific (ports exposed)
├── docker-compose.prod.yml         # prod-specific (no ports exposed)
├── Makefile
├── .env.example
└── README.md
```

---

## 📄 License

MIT – Use freely and adapt for your own needs.