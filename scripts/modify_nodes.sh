#!/bin/bash 

# Connect with ssh to k8s master and modify settings to all VM's in in cluster

# Upload ssh key to Master so that it can connect to worker nodes
echo  "Upload ssh key file"
scp -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@${MASTER_FQDN}:~/.ssh

# Change permissions for the ssh key
ssh -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@${MASTER_FQDN} -C "chmod 0600 $HOME/.ssh/${PRIVATE_KEY_FILE}"

# Substitute env variables before executing script remotely
cp ./helpers/mod_vm_settings.sh ./helpers/mod_vm_settings.bk
cat ./helpers/mod_vm_settings.sh | envsubst > ./helpers/mod_vm_settings.sh.tmp
# cp ./helpers/mod_vm_settings.sh.tmp ./helpers/mod_vm_settings.sh

# Execute mod_vm_settings.sh on remote master node
echo  "Execute ./helpers/mod_vm_settings.sh"
cat ./helpers/mod_vm_settings.sh | ssh -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@${MASTER_FQDN}

