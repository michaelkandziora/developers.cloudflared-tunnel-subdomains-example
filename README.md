# Cloudflare Zero Trust Argo Tunnel with Docker and Nginx

This project sets up a Cloudflare Zero Trust Argo Tunnel using Docker and Nginx. It includes a make script to handle setup, certificate generation, and deployment.

## Prerequisites

- Docker
- Docker Compose

## Setup Instructions

### Step 1: Clone the Repository

```sh
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```

### Step 2: Run the Setup

Run the following command to set up the project. This will prompt you to enter your Cloudflare Remote-Tunnel-Token.

```sh
make
```

### Step 3: Verify the Setup

Ensure that all services are running correctly.

```sh
docker compose ps
```

### Project Structure

```plaintext
my_project/
├── certs/
├── cloudflared/
│   ├── config.yaml
│   └── credentials.json
├── nginx1/
│   ├── conf/
│   │   └── default.conf
│   ├── certs/
│   └── html/
│       └── index.html
├── nginx2/
│   ├── conf/
│   │   └── default.conf
│   ├── certs/
│   └── html/
│       └── index.html
├── nginx3/
│   ├── conf/
│   │   └── default.conf
│   ├── certs/
│   └── html/
│       └── index.html
├── scripts/
│   ├── generate_certs.sh
│   └── copy_certs.sh
├── docker-compose.yaml
├── .env
├── .gitignore
└── README.md
```

### Files and Directories

- **certs/**: Directory for SSL certificates.
- **cloudflared/**: Configuration files for Cloudflare Argo Tunnel.
- **nginx1/**, **nginx2/**, **nginx3/**: Directories for Nginx configurations and HTML files.
- **scripts/**: Contains scripts for generating and copying certificates.
- **docker-compose.yaml**: Docker Compose configuration file.
- **.env**: Environment variable file (ignored in .gitignore).
- **.gitignore**: Git ignore file.
- **README.md**: Project documentation.

### Configuration

#### Cloudflare Argo Tunnel Configuration

The `cloudflared/config.yaml` file contains the configuration for the Cloudflare Argo Tunnel.

```yaml
tunnel: your_tunnel_id
credentials-file: /etc/cloudflared/credentials.json

ingress:
  - hostname: nginx1.meine-domain
    service: http://nginx1:80
  - hostname: nginx2.meine-domain
    service: http://nginx2:80
  - hostname: nginx3.meine-domain
    service: http://nginx3:80
  - service: http_status:404
```

#### Nginx Configuration

The Nginx configuration files in `nginx1/conf/default.conf`, `nginx2/conf/default.conf`, and `nginx3/conf/default.conf` include HTTP to HTTPS redirection.

```nginx
server {
    listen 80;
    server_name nginx1.meine-domain;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name nginx1.meine-domain;

    ssl_certificate /etc/nginx/certs/nginx1.crt;
    ssl_certificate_key /etc/nginx/certs/nginx1.key;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

### Makefile

The `Makefile` handles the setup, certificate generation, and deployment of the project.

```makefile
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
	@echo "Starting all services with docker compose except certs..."
	docker compose up -d cloudflared nginx1 nginx2 nginx3
```

### License

This project is licensed under the MIT License.

### Acknowledgments

- Cloudflare for providing the Argo Tunnel service.
- Docker for containerization.
- Nginx for web server capabilities.
