#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./ui.sh
source ./install/manage-backups.sh

manage_backups
