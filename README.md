# RC configuration

The main objective of this Ansible project is to automate the configuration of the RC component to be deployed in 5G EVE from scratch, with differents steps to be executed, all gathered in main_playbook.yml.

Be sure of using this Ansible in a server which is able to reach the RC server through a SSH connection.

**Note: be aware of having Internet connection and DNS resolution in the RC server to be updated. For that purpose, include *nameserver 8.8.8.8* in */etc/resolv.conf* in case it has not been included in that file or in */etc/network/interfaces* file with the clause *dns-nameservers 8.8.8.8*. Moreover, it is desirable to exchange SSH keys between the RC server and the server in which Ansible will be executed.**

## How to deploy it?

### 1. Install Ansible
 
```sh
$ sudo apt-get update -y
$ sudo apt-get install software-properties-common -y
$ sudo apt-add-repository --yes --update ppa:ansible/ansible
$ sudo apt-get install ansible -y
$ export ANSIBLE_HOST_KEY_CHECKING=False
```

### 2. Install git (in case you haven't done it before)

```sh
$ sudo apt-get update -y
$ sudo apt-get install git -y
```

### 3. Download this RC repository from Gitlab

It is contained in the 5geve-wp3-rc-deployment Ansible project:

```sh
$ cd /tmp
$ git clone git@github.com:5GEVE/5geve-wp3-rc-deployment.git
$ 5geve-wp3-rc-deployment
$ git checkout dev # if exists - if not, use master branch or whatever
```

### 4. Modify Ansible files

In this Ansible project, there are some configuration files that must be completed with all the necessary information in order to reflect the infrastructure to be uploaded with all the steps included here. The configuration files with their description are the following:

* **hosts:** here, you have to include the RC server which will be configured within this Ansible project. The format of each line (PLEASE FOLLOW THIS FORMAT) should be the following: *rc_hostname ansible_host=<RC_IP> ansible_user=<USER> ansible_ssh_pass=<SSH_PASS> ansible_become_pass=<SUDO_PASS>*
* **group_vars:** includes useful variables for the servers defined in the *hosts* file.
	* **all:** applies to all servers. Nothing to change here at the beginning. Only if you want to be stopped with each Ansible role execution, set *prompt_when_finishes_tasks* to true, or false otherwise. Other variables that may require a change are *eve_db_password*, setting the password to be used for the eve user in the DB, *update_module*, which specifies if it is an update (true) or an installation from scratch (false), and *turin_installation*, setting it to true if the installation will be in Turin IWL facility.

### 5. Download 5geve-rc repository from Github

```sh
$ cd /tmp
$ git clone git@github.com:5GEVE/5geve-rc.git
$ cd 5geve-rc
$ git checkout dev # if exists - if not, use master branch or whatever
```

### 6. Compress 5geve-rc project and put it in this Ansible project as file

The easiest way to transfer the 5geve-rc project to the RC server without having to exchange private keys or related (and confidential) information is to compress the 5geve-rc project and send it to the RC server, where it would be decompressed and used afterwards.

```sh
$ cd /tmp
$ tar czf 5geve-rc.tar.gz 5geve-rc
$ mkdir 5geve-wp3-rc-deployment/roles/preparation/files # if not exist
$ mv 5geve-rc.tar.gz 5geve-wp3-rc-deployment/roles/preparation/files
```

### 7. Download 5geve-wp3-rc-handler repository from Gitlab and prepare it properly

```sh
$ cd /tmp
$ git clone git@github.com:5GEVE/5geve-wp3-rc-handler.git
$ cd 5geve-wp3-rc-handler
$ git checkout dev # if exists - if not, use master branch or whatever
```

In case the RC is going to be installed in Turin IWL facility, you need to modify, in /tmp/rc/src/main/resources/application.properties, the following variables:

* **spring.datasource.password:** set the value included in *eve_db_password* in **group_vars/all** Ansible file.
* **ansible.user:** set the value included in *ansible_user* in **hosts** Ansible file.

Then, build the project with Maven (so you need Maven installed in your server)

```sh
$ sudo apt-get update -y
$ sudo apt-get install openjdk-8-jre openjdk-8-jdk maven -y
$ cd /tmp/rc
$ mvn clean install -DskipTests
```

### 8. Compress 5geve-wp3-rc-handler project and put it in this Ansible project as file

The easiest way to transfer the 5geve-wp3-rc-handler project to the RC server without having to exchange private keys or related (and confidential) information is to compress the 5geve-wp3-rc-handler project and send it to the RC server, where it would be decompressed and used afterwards.

```sh
$ cd /tmp
$ mv 5geve-wp3-rc-handler rc
$ tar czf rc.tar.gz rc
$ mv rc.tar.gz 5geve-wp3-rc-deployment/roles/preparation/files
```

### 9. Run Ansible

```sh
$ cd /tmp/5geve-wp3-rc-deployment
$ ansible-playbook -i hosts main_playbook.yml
```

### 10. Other considerations

* In case you want to monitor how much time is spent in each task, you have to modify the file */etc/ansible/ansible.cfg* by uncommenting the callback_whitelist variable (line 83 of the file, "probably"), putting the following value: *callback_whitelist = profile_tasks*

## Copyright

This work has been done by Telcaria Ideas S.L. for the 5G EVE European project under the [Apache 2.0 License](LICENSE).
