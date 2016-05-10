# Webitel orchestration

[![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest)

Orchestrate webitel containers 

## Requirement

- [Docker Engine v1.10+](https://docs.docker.com/engine/installation/)
- [Docker Compose v1.6+](https://docs.docker.com/compose/install/)

## Get webitel v3.3.0

	cd /opt
	curl -L https://github.com/webitel/orchestration/archive/v3.3.0.tar.gz | tar xz
	mv orchestration-3.3.0 orchestration
	cd /opt/orchestration
	./bin/bootstrap.sh pull

## Configure webitel

Change password for root in the [bin/setenv.sh](bin/setenv.sh) file.

## Run webitel

	./bin/webitel-start.sh

Open in browser: http://YOUR_HOST_IP/

- **login**: root
- **password**: secret
- **server**: http://YOUR_HOST_IP/engine
