#!/usr/bin/env bash
set -euo pipefail

source ./ui.sh

HOSTNAME=$(input "System" "Enter hostname:")
USERNAME=$(input "User" "Enter username:")
USER_PASSWORD=$(password "User Password" "Enter password for $USERNAME:")
ROOT_PASSWORD=$(password "Root Password" "Enter root password:")
