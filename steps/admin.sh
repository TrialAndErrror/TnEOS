#!/usr/bin/env bash
set -e

source ./ui.sh

HOSTNAME=$(input "System" "Enter hostname:") || return 1
USERNAME=$(input "User" "Enter username:") || return 1
USER_PASSWORD=$(password "User Password" "Enter password for $USERNAME:") || return 1
ROOT_PASSWORD=$(password "Root Password" "Enter root password:") || return 1
