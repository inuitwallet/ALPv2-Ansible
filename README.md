# ALPv2-Ansible
This [Ansible](https://www.ansible.com/) playbook will install and configure an ALPv2 
server.  
It is intended to be used against an Ubuntu 14.04 Digital Ocean droplet.  
Best results will be with a completely new droplet but the playbook is idempodent so 
changes are only made if they are needed. Running against an existing server may cause 
conflicts if for example, a different user has been used to run the Nu daemon.

##Usage
Copy the `install.sh` script to your machine and run it with  
`sh install.sh`  
  
`install.sh` will add the latest Ansible apt repository and then install git and 
Ansible 2.0. This first step is required as only version 1.5 is available in the 
default repositories.  
Once Ansible 2.0 is installed, `install.sh` will use git to download the rest of the 
ALPv2-Ansible git repo. It will then run the Ansible playbook with the command  
`ansible-playbook playbook.yml -K`  
The `-K` option will cause Ansible to prompt you for your sudo password. If you are 
running `install.sh` as root, you can press `Enter` for a blank password
