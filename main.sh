#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

source ./state.sh

./steps/admin.sh
./steps/theme.sh
./steps/programs.sh
./steps/summary.sh

# Placeholder for real work
dialog --msgbox "All selections collected.\nReady to begin install phase." 8 50
