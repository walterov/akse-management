#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

ensure_package() {
  if ! [ -x "$(command -v ${2})" ]; then
    if [[ "${OSTYPE}" == "linux-gnu" ]]; then
      echo "${2} not found, installing"
      sudo apt-get install -y  $1
    else
      echo "Missing required binary in path: $2"
      return 2
    fi
  fi
}

sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt update
ensure_package git git
ensure_package gettext-base envsubst
ensure_package curl curl
ensure_package kubectl kubectl


