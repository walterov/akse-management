#!/bin/bash

set -o nounset
set -o pipefail

if [ "$UPGRADE_IMAGE" == "TRUE" ]; then
    export FORCE_PARAM="--force"
else
    export FORCE_PARAM=""
fi

aks-engine upgrade \
  --subscription-id ${AZURE_SUBSCRIPTION_ID} \
  --api-model ${HOME}/myagent/_work/6/s/_out/${DNS_PREFIX}/apimodel.json \
  --location ${AZURE_LOCATION} \
  --resource-group ${DNS_PREFIX}-rg \
  --upgrade-version ${K8S_UPGRADE_VER} $FORCE_PARAM \
  --client-id ${AZURE_CLIENT_ID} \
  --client-secret ${AZURE_CLIENT_SECRET} \
  --azure-env AzureStackCloud
