# Webitel orchestration

[![Build Status](https://travis-ci.org/webitel/orchestration.svg?branch=master)](https://travis-ci.org/webitel/orchestration) [![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest) 

Orchestrate webitel containers 

## Requirement

- [Docker Engine v1.11+](https://docs.docker.com/engine/installation/)
- [Docker Compose v1.7+](https://docs.docker.com/compose/install/)

## Download the source code with Git

Webitel is constantly evolving therefore, we advise you to download and use the latest tagged release. 

	$ cd /opt
	$ git pull https://github.com/webitel/orchestration.git
	$ cd /opt/orchestration
	$ git tag -l
	
	v3.2.0
	v3.2.1
	v3.2.2
	v3.3.0
	
	$ git checkout v3.3.0

## Configure webitel

By default Webitel comes with an env/*.example file. You'll need to copy this file to new without .example.

It's now just a case of editing new **env/environment** file and setting the values of your setup.

## Start webitel

	./bin/webitel-start.sh

Open in browser: http://YOUR_HOST_IP/

- **login**: root
- **password**: secret
- **server**: http://YOUR_HOST_IP/engine
