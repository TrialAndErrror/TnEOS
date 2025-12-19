#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

source ./state.sh
source ./ui.sh

source ./steps/admin.sh
source ./steps/programs.sh
source ./steps/summary.sh

# Placeholder for real work
gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "All selections collected." "Ready to begin install phase."
gum input --placeholder "Press Enter to continue..." --width 0 > /dev/null
