# Stella: MariaDB + Adminer

Lightweight Docker Compose stack for a local or server-hosted MariaDB instance with Adminer.

## Requirements

- Docker Engine
- Docker Compose v2+
- `make`

## Setup

1. Create a local env file:

   ```bash
   cp .env.template .env
   ```

2. Set a non-default `MARIADB_ROOT_PASSWORD` in `.env`.
3. Create the shared Docker network:

   ```bash
   make install_network
   ```

## Run

Development mode exposes MariaDB on `3306` and Adminer on `8081`:

```bash
make start_dev
make startall_dev
```

Open Adminer at [http://localhost:8081](http://localhost:8081).

Production mode keeps the same services without host port bindings:

```bash
make start
make startall
```

## Common Commands

```bash
make              # Show helper
make help         # List available targets
make check        # Validate .env presence and Compose config
make status       # Show container state
make logs         # Follow service logs
make envcheck     # Show loaded env keys with secrets masked
make down         # Stop containers
make reset        # Remove containers
make reset-all    # Remove containers, volumes, and orphans
```

## Structure

```text
.
├── docker-compose.yml           # base services and network
├── docker-compose.override.yml  # development ports
├── docker-compose.prod.yml      # production restart policy
├── Makefile                     # local workflow entrypoint
├── .env.template                # environment template
└── AGENTS.md                    # contributor guide
```

## Notes

- MariaDB data is persisted in `./data/`.
- Services join the external Docker network `interservices`.
- `db` now exposes a health check used by Adminer startup ordering.
