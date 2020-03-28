#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

AKSE_REPO="Azure/aks-engine"
AKSE_RELEASE="v0.43.1"
AKSE_BRANCH="branch"

curl -O https://github.com/${AKSE_REPO}/downloads/${AKSE_RELEASE}

# OR

git clone https://github.com/${AKSE_REPO} -b ${AKSE_BRANCH}
make bootstrap
make buid