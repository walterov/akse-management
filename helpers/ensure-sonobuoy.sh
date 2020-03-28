#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SONOBUOY_GITHUB_USER="vmware-tanzu"
SONOBUOY_TAG="0.17.0"
SONOBUOY_INSTALL_DIR="/usr/local/bin"
USE_SUDO="true"

# runs the given command as root (detects if we are root already)
runAsRoot() {
  local CMD="$*"

  if [ $EUID -ne 0 ] && [ "$USE_SUDO" = "true" ]; then
    CMD="sudo $CMD"
  fi

  $CMD
}

# downloadFile downloads the latest binary package and also the checksum
# for that binary.
downloadFile() {
  SONOBUOY_DIST="sonobuoy_${SONOBUOY_TAG}_linux_amd64.tar.gz"
  DOWNLOAD_URL="https://github.com/$SONOBUOY_GITHUB_USER/sonobuoy/releases/download/v${SONOBUOY_TAG}/${SONOBUOY_DIST}"
  SONOBUOY_TMP_ROOT="$(mktemp -dt sonobuoy-installer-XXXXXX)"
  SONOBUOY_TMP_FILE="${SONOBUOY_TMP_ROOT}/${SONOBUOY_DIST}"
  echo "Downloading ${DOWNLOAD_URL}"
  if type "curl" > /dev/null; then
    curl -SsL "${DOWNLOAD_URL}" -o "${SONOBUOY_TMP_FILE}"
  elif type "wget" > /dev/null; then
    wget -q -O "${SONOBUOY_TMP_FILE}" "${DOWNLOAD_URL}"
  fi
}

installFile() {
  SONOBUOY_TMP="$SONOBUOY_TMP_ROOT/sonobuoy"

  mkdir -p "$SONOBUOY_TMP"
  tar xf "$SONOBUOY_TMP_FILE" -C "$SONOBUOY_TMP"
  SONOBUOY_TMP_BIN="$SONOBUOY_TMP"
  echo "Preparing to install sonobuoy into ${SONOBUOY_INSTALL_DIR}"
  runAsRoot cp "$SONOBUOY_TMP_BIN/sonobuoy" "$SONOBUOY_INSTALL_DIR"
  echo "sonobuoy installed into $SONOBUOY_INSTALL_DIR/sonobuoy"
}

ensure_sonobuoy_binary() {
  if ! [ -x "$(command -v sonobuoy)" ]; then
    if [[ "${OSTYPE}" == "linux-gnu" ]]; then
      echo 'sonobuoy not found, installing'
      downloadFile
      installFile
    else
      echo "Missing required binary in path: sonobuoy"
      return 2
    fi
  fi
}

ensure_sonobuoy_binary
