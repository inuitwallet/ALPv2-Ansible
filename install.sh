#!/usr/bin/env bash

echo updating
sudo apt-get update

echo installing git and add-apt-repository utility
sudo apt-get install git software-properties-common

echo adding ansible PPA repository
sudo apt-add-repository ppa:ansible/ansible

echo updating
sudo apt-get update

echo installing ansible 2
sudo apt-get install ansible

echo fetching ansible repo
git clone http://github.com/inuitwallet/ALPv2-Ansible

echo moving to the Ansible directory
cd ALPv2-Ansible

echo running Ansible playbook to install ALPv2
ansible-playbook playbook.yml -K
