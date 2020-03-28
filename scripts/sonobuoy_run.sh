#!/bin/bash

set -o nounset
set -o pipefail

REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
cd "${REPO_ROOT}" || exit 1

./sonobuoy run --wait
results=$(./sonobuoy retrieve)
./sonobuoy results $results
