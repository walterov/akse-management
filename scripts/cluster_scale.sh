#!/bin/bash

set -o nounset
set -o pipefail

aks-engine scale \
    --subscription-id ${AZURE_SUBSCRIPTION_ID} \
    --api-model ${HOME}/myagent/_work/1/s/_out/${DNS_PREFIX}/apimodel.json \
    --location ${AZURE_LOCATION} \
    --resource-group ${DNS_PREFIX}-rg \
    --client-id ${AZURE_CLIENT_ID} \
    --client-secret ${AZURE_CLIENT_SECRET} \
    --new-node-count ${NEW_NODE_COUNT} \
    --node-pool ${NODE_POOL_NAME} \
    --master-FQDN ${MASTER_FQDN} \
    --azure-env AzureStackCloud   


