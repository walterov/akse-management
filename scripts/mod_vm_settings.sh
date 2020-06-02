#!/bin/bash 

# Add proxy settings to all VM's in in cluster

# Number of nodes in the cluster
n=$(kubectl get nodes --no-headers | wc -l)

# extract node names into an array
for i in $(seq $n)
do
    # Get a line from the memberlist
    l="${i}p"
    MEMBER[${i}]=$(kubectl get nodes --no-headers | sed -n $l)

    # Remove all trailing characters starting at the first blank char
    temp=${MEMBER[${i}]} 
    MEMBER[${i}]=${temp%%[ ]*}

done
echo "These are the cluster nodes: ${MEMBER[*]}"

# Connect to each node with SSH
# Change VM Settings on each VM
echo "Execute changes to VM settings for all nodes, example proxy settings"

for i in $(seq $n)
do
    ssh MEMBER[${i}] -i ${HOME}/.ssh/${PRIVATE_KEY_FILE} -C "sudo echo 'export http_proxy=http://69.162.97.93:3128/' >> /etc/profile"
done

echo "Finish changes to all VMs"