#!/bin/bash

set -o nounset
set -o pipefail

#REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
#cd "${REPO_ROOT}" || exit 1

#source "${REPO_ROOT}/helpers/cluster_defaults.env"

case "$MONITORING_AZURE" in
  FALSE) cat helpers/cluster_template.tpl | envsubst > cluster_definition.json ;;
  TRUE)  cat helpers/cluster_azuremonitor_template.tpl | envsubst > cluster_definition.json ;;
  T)     cat helpers/cluster_azuremonitor_template.tpl | envsubst > cluster_definition.json ;;
  *)     cat helpers/cluster_template.tpl | envsubst > cluster_definition.json ;;
esac