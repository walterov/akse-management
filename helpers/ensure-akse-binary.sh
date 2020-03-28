#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

AKSE_GITHUB_USER="Azure"
AKSE_TAG="v0.43.1"
AKSE_INSTALL_DIR="/usr/local/bin"
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
  AKSE_DIST="aks-engine-${AKSE_TAG}-linux-amd64.tar.gz"
  DOWNLOAD_URL="https://github.com/$AKSE_GITHUB_USER/aks-engine/releases/download/${AKSE_TAG}/${AKSE_DIST}"
  AKSE_TMP_ROOT="$(mktemp -dt akse-installer-XXXXXX)"
  AKSE_TMP_FILE="${AKSE_TMP_ROOT}/${AKSE_DIST}"
  echo "Downloading ${DOWNLOAD_URL}"
  if type "curl" > /dev/null; then
    curl -SsL "${DOWNLOAD_URL}" -o "${AKSE_TMP_FILE}"
  elif type "wget" > /dev/null; then
    wget -q -O "${AKSE_TMP_FILE}" "${DOWNLOAD_URL}"
  fi
}

installFile() {
  AKSE_TMP="$AKSE_TMP_ROOT/aks-engine"

  mkdir -p "$AKSE_TMP"
  tar xf "$AKSE_TMP_FILE" -C "$AKSE_TMP"
  AKSE_TMP_BIN="$AKSE_TMP/aks-engine-${AKSE_TAG}-linux-amd64"
  echo "Preparing to install aks-engine into ${AKSE_INSTALL_DIR}"
  runAsRoot cp "$AKSE_TMP_BIN/aks-engine" "$AKSE_INSTALL_DIR"
  echo "aks-engine installed into $AKSE_INSTALL_DIR/aks-engine"
}

ensure_akse_binary() {
  if ! [ -x "$(command -v aks-engine)" ]; then
    if [[ "${OSTYPE}" == "linux-gnu" ]]; then
      echo 'aks-engine not found, installing'
      downloadFile
      installFile
    else
      echo "Missing required binary in path: aks-engine"
      return 2
    fi
  fi
}

ensure_akse_binary
