#!/bin/bash 

# Connect with ssh to k8s master and modify settings to all VM's in in cluster

# Upload ssh key to Master so that it can connect to worker nodes
echo  "Upload ssh key file"
scp -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@${MASTER_FQDN}:~/.ssh

# Change permissions for the ssh key
ssh ${MASTER_FQDN} -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} -C "chmod 0600 $HOME/.ssh/${PRIVATE_KEY_FILE}"

# Execute mod_vm_settings.sh on remote master node
echo  "Execute ./helpers/mod_vm_settings.sh"
cat ./helpers/mod_vm_settings.sh | ssh -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@${MASTER_FQDN}

