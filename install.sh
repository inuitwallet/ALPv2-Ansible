#!/usr/bin/env bash

echo updating
sudo apt-get update

echo installing add-apt-repository utility
sudo apt-get install software-properties-common

echo adding ansible PPA repository
sudo apt-add-repository ppa:ansible/ansible

echo updating
sudo apt-get update

echo installing ansible 2
sudo apt-get install ansible

echo running Ansible playbook to install ALPv2
ansible-playbook playbook.yml -K
