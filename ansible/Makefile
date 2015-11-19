#
# Tasks Makefile
# ==============
#
# Shortcuts for various tasks.
#

PRIVATE_KEY=~/.ssh/id_rsa

install:
	@(ansible-playbook -i hosts boot.yml -u root -t install --private-key $(PRIVATE_KEY))

start:
	@(ansible-playbook -i hosts boot.yml -u root -t start --private-key $(PRIVATE_KEY))

stop:
	@(ansible-playbook -i hosts boot.yml -u root -t stop --private-key $(PRIVATE_KEY))

update:
	@(ansible-playbook -i hosts software.yml -u root -t update --private-key $(PRIVATE_KEY))

ps:
	@(ansible docker -i hosts -m shell -a "docker ps -a" -u root --private-key $(PRIVATE_KEY))

setup:
	@(ansible all -i hosts -m setup -u root --private-key $(PRIVATE_KEY))

ping:
	@(ansible all -i hosts -m ping -u root --private-key $(PRIVATE_KEY))

show-tasks:
	@(ansible-playbook -i hosts playbook.yml --list-tasks)

show-hosts:
	@(ansible-playbook -i hosts playbook.yml --list-hosts)

