# Webitel orchestration

[![Build Status](https://travis-ci.org/webitel/orchestration.svg?branch=master)](https://travis-ci.org/webitel/orchestration) [![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest)

Orchestrate webitel containers

## Requirement

- [Docker CE Stable](https://www.docker.com/community-edition#/download/)
- [Docker Compose v1.15+](https://docs.docker.com/compose/install/)

## Download the source code with Git

Webitel is constantly evolving therefore, we advise you to download and use the latest tagged release.

	$ cd /opt
	$ git clone https://github.com/webitel/orchestration.git
	$ cd /opt/orchestration
	$ git tag -l
	$ git checkout v3.11.7

## Configure webitel

By default Webitel comes with an env/*.example file. You'll need to copy this file to new without .example.

It's now just a case of editing new **env/environment** file and setting the values of your setup.

	$ sudo cat /opt/orchestration/etc/sysctl.conf >> /etc/sysctl.conf
	$ sudo sysctl -p

For Ubuntu:

	$ sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.tcpdump


## Start webitel

	./bin/bootstrap.sh up -d

Open in browser: http://YOUR_HOST_IP/

- **login**: root
- **password**: secret
- **server**: http://YOUR_HOST_IP/engine

### update certificate to X.509v3

	sudo -s
	docker exec -it freeswitch openssl req -new -newkey rsa:2048 -x509 -sha256 -days 900 -nodes -keyout /certs/key.pem -out /certs/cert.pem
	cat /opt/webitel/ssl/key.pem /opt/webitel/ssl/cert.pem > /opt/webitel/ssl/dtls-srtp.pem

## Autostart webitel

	$ sudo cp /opt/orchestration/etc/cron.d/webitel /etc/cron.d/
