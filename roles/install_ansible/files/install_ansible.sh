#!/bin/bash

sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y

ANSIBLE_CHECK_COUNT_WORDS=$(cat /etc/profile | grep ANSIBLE_HOST_KEY_CHECKING | wc -w)
if [ "$ANSIBLE_CHECK_COUNT_WORDS" -eq 0 ]; then
	echo 'export ANSIBLE_HOST_KEY_CHECKING=False' | sudo tee -a /etc/profile > /dev/null
fi
