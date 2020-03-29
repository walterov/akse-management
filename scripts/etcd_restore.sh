#!/usr/bin/env bash

set -o nounset
set -o pipefail

# Number of members in the etcd cluster
n=$(sudo etcdctl member list | wc -l)

# extract member urls into an array
for i in $(seq $n)
do
    # Get a line from the memberlist
    l="${i}p"
    MEMBER[${i}]=$(sudo etcdctl member list | sed -n $l)

    # Remove prefix and suffix
    temp=${MEMBER[${i}]#*peerURLs=}
    MEMBER[${i}]=${temp%client*}

done
echo "These are the cluster members: ${MEMBER[*]}"

# Build member string
MEMBER_STR=""
for i in $(seq $n)
do
    if [ $i -eq 1 ]
    then
        MEMBER_STR="m${i}=${MEMBER[$i]}"
    else
        MEMBER_STR="${MEMBER_STR},m${i}=${MEMBER[$i]}"
    fi
done

# remove spaces
MEMBER_STR=$(echo -e "${MEMBER_STR}" | tr -d '[:space:]')
echo "this is MEMBER_STR = ${MEMBER_STR}"

# Restore snapshot file
echo  "Restore snapshot in each member"

for i in $(seq $n)
do
    sudo ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
                --name m${i} \
                --initial-cluster ${MEMBER_STR} \
                --initial-cluster-token etcd-cluster-1 \
                --initial-advertise-peer-urls ${MEMBER[$i]}
done

# start etcd with the new data directories
echo "start etcd with the new data directories"

for i in $(seq $n)
do
    h=${MEMBER[${i}]%:*}
    sudo etcd \
    --name m${i} \
    --listen-client-urls ${h}:2379 \
    --advertise-client-urls ${h}:2379 \
    --listen-peer-urls ${MEMBER[$i]}
done


