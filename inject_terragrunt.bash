#!/usr/bin/env bash

set -euo pipefail

readonly BASE_DIR="/home/cnb/.terraform-spring-boot/tofu"

TARGET_VERSION="${terraformVersion:-}"
if [[ -z "${TARGET_VERSION}" ]]; then
    echo "Error: The terraformVersion variable is not set." >&2
    exit 1
fi

TARGET_DIR="${BASE_DIR}/v${TARGET_VERSION}"
MARKER_FILE="${TARGET_DIR}/fixed"
SOURCE_BINARY="/usr/local/bin/terragrunt"
SYMLINK_PATH="${TARGET_DIR}/tofu"

if [[ ! -x "${SOURCE_BINARY}" ]]; then
    echo "Error: Source binary '${SOURCE_BINARY}' does not exist or is not executable." >&2
    exit 1
fi

if [[ ! -f "${MARKER_FILE}" ]]; then
    mkdir -p "${TARGET_DIR}"

    if [[ -e "${SYMLINK_PATH}" || -L "${SYMLINK_PATH}" ]]; then
        BACKUP_PATH="${SYMLINK_PATH}.bak.$(date +%Y%m%d%H%M%S)"
        mv "${SYMLINK_PATH}" "${BACKUP_PATH}"
        echo "Existing tofu file found and moved to '${BACKUP_PATH}'."
    fi

    ln -sf "${SOURCE_BINARY}" "${SYMLINK_PATH}"
    touch "${MARKER_FILE}"
    echo "Setup successfully completed for OpenTofu/Terragrunt v${TARGET_VERSION}."
else
    echo "Configuration already exists for v${TARGET_VERSION}. No action required."
fi