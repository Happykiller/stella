# Repository Guidelines

## Project Structure & Module Organization
This repository is a small Docker Compose stack for MariaDB and Adminer. Core files live at the root:

- `docker-compose.yml`: base services (`db`, `adminer`) and the external `interservices` network.
- `docker-compose.override.yml`: development-only port mappings.
- `docker-compose.prod.yml`: production restart settings.
- `Makefile`: the primary developer interface for start, stop, logs, and cleanup tasks.
- `.env.template`: template for local configuration; copy it to `.env` before starting the stack.
- `data/`: MariaDB persistent volume data, created locally at runtime.

## Build, Test, and Development Commands
Use `make` targets instead of raw `docker compose` where possible:

- `make start_dev`: start the stack with development ports exposed.
- `make startall_dev`: rebuild and start the development stack.
- `make start`: start the production-style stack without exposed ports.
- `make` or `make help`: show the available workflow commands.
- `make check`: validate `.env` presence and merged Compose configuration.
- `make status`: show running containers.
- `make logs`: stream container logs.
- `make down` / `make reset` / `make reset-all`: stop, remove containers, or fully clean volumes.
- `make envcheck`: verify the loaded `.env` keys without printing secret values.

Run `make install_network` once if the shared `interservices` Docker network does not already exist.

## Coding Style & Naming Conventions
Keep YAML and Makefile indentation consistent with the current files: two spaces in Compose YAML, tabs for Make recipes. Preserve existing service and container naming (`db`, `adminer`, `stella`, `stella_admin`). Name new compose overrides descriptively, for example `docker-compose.ci.yml`.

## Testing Guidelines
There is no automated test suite yet. Validate changes with configuration and runtime checks:

- `docker compose config` to verify merged Compose syntax.
- `make start_dev` followed by `make status` to confirm both services start.
- `make logs` to inspect MariaDB/Adminer startup errors.
- Confirm Adminer responds on `http://localhost:8081` in development mode.

If you add tests later, place them near the tooling they cover and document the command here.

## Commit & Pull Request Guidelines
Git history is minimal (`initial commit`, `refacto expo`), so prefer short, imperative commit subjects such as `add healthcheck for mariadb`. Keep commits focused on one operational change. PRs should include the purpose, affected files, any required `.env` or network setup changes, and screenshots only when UI behavior in Adminer is relevant.

## Configuration Tips
Do not commit secrets in `.env`. Use `.env.template` as the source of default keys and keep exposed development ports aligned with `docker-compose.override.yml` (`3306`, `8081`).
