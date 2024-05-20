.PHONY: all setup certs start check_env check_docker

all: check_env certs start

setup:
	@read -p "Enter your Cloudflare Remote-Tunnel-Token: " TUNNEL_TOKEN; \
	echo "TUNNEL_TOKEN=$$TUNNEL_TOKEN" > .env; \
	echo "Token stored in .env file."

check_docker:
	@docker --version > /dev/null 2>&1 || { echo >&2 "Docker is not installed. Please install Docker and try again."; exit 1; }

check_env:
	@if [ ! -f .env ]; then \
		echo ".env file not found, running setup..."; \
		$(MAKE) setup; \
	elif ! grep -q "^TUNNEL_TOKEN=" .env; then \
		echo "TUNNEL_TOKEN not found in .env, running setup..."; \
		$(MAKE) setup; \
	fi

certs: check_docker
	@echo "Deploying certs container to generate certificates..."
	docker compose up certs --force-recreate --no-deps
	@echo "Making copy script executable and running it..."
	chmod +x scripts/copy_certs.sh
	sudo ./scripts/copy_certs.sh

start: check_docker
	@echo "Starting all services with docker compose..."
	docker compose up -d cloudflared nginx1 nginx2 nginx3

