# Automatically start containers

## upstart

Copy webitel.conf into the /etc/init/webitel.conf

## systemd

Copy webitel.service into the /etc/systemd/system/webitel.service

	systemctl enable webitel
	systemctl start webitel