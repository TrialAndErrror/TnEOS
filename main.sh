#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

source ./state.sh

source ./steps/admin.sh
source ./steps/theme.sh
source ./steps/programs.sh
source ./steps/summary.sh

# Placeholder for real work
dialog --msgbox "All selections collected.\nReady to begin install phase." 8 50
