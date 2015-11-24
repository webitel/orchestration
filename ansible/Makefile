#
# Tasks Makefile
# ==============
#
# Shortcuts for various tasks.
#

PRIVATE_KEY=~/.ssh/id_rsa

install:
	@(ansible-playbook -i hosts playbooks/boot.yml -u root -t install --private-key $(PRIVATE_KEY))

start:
	@(ansible-playbook -i hosts playbooks/boot.yml -u root -t start --private-key $(PRIVATE_KEY))

stop:
	@(ansible-playbook -i hosts playbooks/boot.yml -u root -t stop --private-key $(PRIVATE_KEY))

update:
	@(ansible-playbook -i hosts playbooks/software.yml -u root -t update --private-key $(PRIVATE_KEY))

dns-add:
	@(ansible-playbook playbooks/aws.yml -t dns_add) 

dns-del:
	@(ansible-playbook playbooks/aws.yml -t dns_del) 

ps:
	@(ansible docker -i hosts -m shell -a "docker ps -a" -u root --private-key $(PRIVATE_KEY))


ping:
	@(ansible all -i hosts -m ping -u root --private-key $(PRIVATE_KEY))

setup:
	@(ansible all -i hosts -m setup -u root --private-key $(PRIVATE_KEY))

