#!/usr/bin/env bash

mkdir $HOME/${BACKUP_PATH}

# Connect to master with SSH
# Execute backup
echo "Execute cluster config backup, that is etcd snaptshot"
ssh $MASTER_IP -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} -C "sudo ETCDCTL_API=3 etcdctl  --cert="/etc/kubernetes/certs/etcdclient.crt"  --key="/etc/kubernetes/certs/etcdclient.key"  --cacert="/etc/kubernetes/certs/ca.crt"  snapshot save snapshot.db"

#Verify backup
echo  "Verify backup"
ssh $MASTER_IP -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} -C "sudo ETCDCTL_API=3 etcdctl --write-out=table snapshot status snapshot.db"

# Download snapshot to calling VM agent save it in BACKUP_PATH
echo  "download backup file"
scp -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@$MASTER_IP:~/snapshot.db $HOME/${BACKUP_PATH}
