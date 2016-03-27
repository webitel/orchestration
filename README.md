# Webitel orchestration

[![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest)

Orchestrate webitel containers 

## Requirement

- [Docker Engine v1.10+](https://docs.docker.com/engine/installation/)
- [Docker Compose v1.6+](https://docs.docker.com/compose/install/)

## Get webitel v3.2.1

	cd /opt
	curl -L https://github.com/webitel/orchestration/archive/v3.2.1.tar.gz | tar xz
	mv orchestration-3.2.1 orchestration
	cd /opt/orchestration
	./bin/bootstrap.sh esf pull
	./bin/bootstrap.sh esf up -d
	./bin/bootstrap.sh pull

## Configure webitel

Change password for root and set FQDN for webitel’s host in the [bin/setenv.sh](bin/setenv.sh) file.

## Run webitel

	./bin/bootstrap.sh up -d

Open in browser: http://FQDN/

- **login**: root
- **password**: CHANGE_ROOT_PASSWORD
- **server**: http://FQDN/engine
