# Webitel orchestration
Orchestrate webitel containers 

## Requirement

- [Docker](https://docs.docker.com/engine/installation/debian/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Get webitel 3.1

	curl -L https://github.com/webitel/orchestration/archive/v.3.1.tar.gz | tar xz && mv orchestration-v.3.1 /opt/webitel
	cd /opt/webitel
	docker-compose pull

## Change password & IP

Change password for root user and set Your IP in the `common.env` file.

## Run webitel 3.1

	docker-compose up -d

Open in browser: http://YOUR_IP:10020/

- **login**: root
- **password**: CHANGE_ROOT_PASSWORD
- **server**: http://YOUR_IP:10022/