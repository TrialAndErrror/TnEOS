#!/usr/bin/env bash
set -e

source ./ui.sh

# Get current system info (already set during Arch install)
HOSTNAME=$(hostname)
USERNAME=$USER

gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "System Information" \
  "Hostname: $HOSTNAME" \
  "User: $USERNAME" \
  "" \
  "This information was detected from your system."

echo ""
gum confirm "Continue with installation?" || return 1
