# Webitel orchestration

[![Join the chat at https://gitter.im/webitel/support](https://badges.gitter.im/webitel/support.svg)](https://gitter.im/webitel/support?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest)

Orchestrate webitel containers 

## Requirement

- [Docker Engine](https://docs.docker.com/engine/installation/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Get webitel 3.1

	cd /opt
	curl -L https://github.com/webitel/orchestration/archive/v.3.1.tar.gz | tar xz
	mv orchestration-v.3.1 webitel
	cd /opt/webitel
	docker-compose pull

## Configure webitel

Change password for root, token key  and set Your IP in the [common.env](common.env) file.

## Run webitel

	docker-compose up -d

Open in browser: http://YOUR_IP:10020/

- **login**: root
- **password**: CHANGE_ROOT_PASSWORD
- **server**: http://YOUR_IP:10022/
