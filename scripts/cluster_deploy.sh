#!/bin/bash

set -o nounset
set -o pipefail

export CLUSTER_DEFINITION="cluster_definition.json"

NOW=`date +%Y%m%d%H%M%S`
export DNS_PREFIX=${DNS_PREFIX:-$NOW}

#source "${REPO_ROOT}/helpers/akse_deploy.sh"

# Deploy cluster
aks-engine deploy \
    --azure-env AzureStackCloud \
    --location ${AZURE_LOCATION} \
    --api-model ${CLUSTER_DEFINITION} \
    --resource-group ${DNS_PREFIX}-rg \
    --output-directory _out/${DNS_PREFIX} --force-overwrite \
    --client-id ${AZURE_CLIENT_ID} \
    --client-secret ${AZURE_CLIENT_SECRET} \
    --subscription-id ${AZURE_SUBSCRIPTION_ID} \
    --dns-prefix ${DNS_PREFIX} \
    --auto-suffix

# Configure kubectl with the new kubeconfig
echo "Configure kubectl with the new kubeconfig ${DNS_PREFIX}"
THIS_DIR=$(pwd)
OUTPUT_DIR=$(find . -name ${DNS_PREFIX})
OUTPUT_DIR="${OUTPUT_DIR:2}"
mkdir $HOME/.kube
cp ${THIS_DIR}/${OUTPUT_DIR}/kubeconfig/kubeconfig.${AZURE_LOCATION}.json ${HOME}/.kube/kubeconfig.${AZURE_LOCATION}.${DNS_PREFIX}.json
cp ${HOME}/.kube/kubeconfig.${AZURE_LOCATION}.${DNS_PREFIX}.json $HOME/.kube/config
kubectl cluster-info