This repos is use to set ansible master node using this config:

#sudo apt update
#sudo apt install ansible

#sudo vim /etc/ansible/hosts

[Node-Servers]

[Node-Servers]
23.22.54.216 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/keypair_pem



#ansible-playbook -i /etc/ansible/hosts setup_webserver.yml --private-key=/path/to/keypair_pem

#ansible-playbook -i /etc/ansible/hosts setup_webserver.yml


CHECK APACHE STATUS

#sudo systemctl status apache2

#open port 80 on target server and check the webpage
