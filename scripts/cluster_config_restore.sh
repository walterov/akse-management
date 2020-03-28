#!/usr/bin/env bash

if test -f "${HOME}/${BACKUP_PATH}/snapshot.db"; then
    # Upload snapshot to calling VM agent save it in BACKUP_PATH
    echo  "Upload snapshot file"
    scp -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${HOME}/${BACKUP_PATH}/snapshot.db ${USERNAME}@${MASTER_IP}:~/

    # Upload etcd_restore.sh script and execute it
    echo  "Upload etcd_restore.sh file"
    scp -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${REPO_ROOT}/scripts/etcd_restore.sh ${USERNAME}@$MASTER_IP:~/ 

    # Exec etcd_restore.sh script 
    echo  "Exec etcd_restore.sh script"
    ssh $MASTER_IP -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} 'sudo chmod +x ./etcd_restore.sh; sudo ./etcd_restore.sh > etcd_restore.log' -y

    # Download restore log to calling VM agent save it in BACKUP_PATH
    echo  "download etcd_restore.log file"
    scp -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} ${USERNAME}@${MASTER_IP}:~/etcd_restore.log ${HOME}/${BACKUP_PATH}
    cat ${HOME}/${BACKUP_PATH}/etcd_restore.log

fi    

    