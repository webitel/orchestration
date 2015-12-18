# Webitel orchestration
Orchestrate webitel containers 

## Requirement

- [Docker](https://docs.docker.com/engine/installation/debian/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Install

## Configure without SSL

Change password for root user and set Your IP in the `common.env` file.

## Run

	docker-compose pull
	docker-compose up -d

Open in the browser: http://YOUR_IP:10020/

**login**: root
**password**: CHANGE_ROOT_PASSWORD
**server**: http://YOUR_IP:10022/