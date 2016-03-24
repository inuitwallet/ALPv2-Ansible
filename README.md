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
Answer the questions and Ansible will do the rest.  
  
  
##Explanation
  
`install.sh` will add the latest Ansible apt repository and then install git and 
Ansible 2.0. This first step is required as only version 1.5 is available in the 
default repositories.  
Once Ansible 2.0 is installed, `install.sh` will use git to download the rest of the 
ALPv2-Ansible git repo. It will then run the Ansible playbook with the command  
`ansible-playbook playbook.yml -K`  
The `-K` option will cause Ansible to prompt you for your sudo password. If you are 
running `install.sh` as root, you can press `Enter` for a blank password.  
  
The playbook will ask for a few things:  
  * The name of your pool.  
  * The domain name on which your pool is accessible. You can enter an IP address here if necessary.  
  * The email address to use for notification of the expiry of the pools SSL certificate. This playbook will set up the pool to serve all content over https using a free certificate from [Let's Encrypt](https://letsencrypt.com). If you don't want to do this and just want to serve content over plain http instead, leave this email option blank.  
 
Once it is running the playbook will run the roles in a certain order and will fully configure the pool. Here is a brief run down of what it does:  
  * Update all software through apt-get and install the dependencies needed for ALPv2.
  * Create an `alp` user and a `nud` user who will run those programs.
  * Install and configure [PostgreSQL](http://www.postgresql.org/) 9.5, the database needed by ALPv2.
  * Install and Configure [Nginx](https://www.nginx.com/resources/wiki/), a [reverse proxy](https://en.wikipedia.org/wiki/Reverse_proxy) that makes it safe for ALPv2 to be served over http(s).
  * Install and configure `nud`, needed for payouts from the pool.
  * Install and configure ALPv2.
  * Install and configure [Supervisord](http://supervisord.org/), used to manage the four programs listed above and restart them if they crash.
  * Configure the firewall to allow traffic only on port 22 (SSH), 80 (HTTP) and optionally 443 (HTTPS).
  * Optionally, register a free SSL certificate and reconfigure Nginx to encrypt traffic to the ALPv2 server (recommended)
  
  

###Control and further setup

Once everything is installed you can control the ALP server using Supervisord. The main control to master is:  
`sudo supervisorctl status`.  
This wil show you the current status of your pool and should output something like this:  
```
$ sudo supervisorctl status
alp                              RUNNING    pid 9835, uptime 0:18:44
nginx                            RUNNING    pid 12259, uptime 0:18:17
nud                              RUNNING    pid 9828, uptime 0:18:45
postgresql                       RUNNING    pid 9830, uptime 0:18:44
```
You can start and stop programs by running `sudo supervisorctl start/stop <program_name>`.  
Alternatively, you can start or stop all programs with `sudo supervisorctl start/stop all`.  
  
The `alp` user can run `sudo supervisorctl *` without having to enter a sudo password (`alp` cannot run any other sudo commands in this way).

There is a directory in the `alp` home directory which contains all the logs generated by the supervisrod controlled programs. Look in `/home/alp/logs` for all start up and shutdown behaviour of nginx, postgresq;, alp and nud. You will also see a `/home/alp/logs/nginx` directory which conatins access and error logs from nginx so you can see who has been accessing your pool. The only log that isn't there is the `nud` `debug.log`. That is still in `/home/nud/.nu/debug.log` as that is set as the data directory when starting nud. 

Once The script has completed with no errors, you are free to configure your pool. The config files can be found in `/home/alp/code/config/*`
