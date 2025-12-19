#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./state.sh
source ./ui.sh

# Step navigation
CURRENT_STEP=1

while true; do
  case $CURRENT_STEP in
    1)
      if source ./steps/admin.sh; then
        CURRENT_STEP=2
      else
        exit 1  # Can't go back from first step
      fi
      ;;
    2)
      if source ./steps/programs.sh; then
        CURRENT_STEP=3
      else
        CURRENT_STEP=1  # Go back
      fi
      ;;
    3)
      if source ./steps/summary.sh; then
        CURRENT_STEP=4
        break
      else
        CURRENT_STEP=2  # Go back
      fi
      ;;
  esac
done

# Placeholder for real work
gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "All selections collected." "Ready to begin install phase."
gum input --placeholder "Press Enter to continue..." --width 0 > /dev/null
