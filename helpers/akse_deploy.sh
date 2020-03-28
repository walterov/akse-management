#!/bin/bash -e

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
