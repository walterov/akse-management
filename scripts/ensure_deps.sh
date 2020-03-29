#!/bin/bash

echo ensure_deps

set -o nounset
set -o pipefail 

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
cd "${REPO_ROOT}" || exit 1

source "${REPO_ROOT}/helpers/ensure-packages.sh"
source "${REPO_ROOT}/helpers/ensure-akse-binary.sh"
source "${REPO_ROOT}/helpers/ensure-sonobuoy.sh"
