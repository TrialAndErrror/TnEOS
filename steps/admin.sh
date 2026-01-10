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

# Ask if desktop or laptop
DEVICE_TYPE=$(gum choose --header "Select your device type:" "Laptop" "Desktop")

# Display selected device type
gum style --bold --foreground 2 "✓ Device type: $DEVICE_TYPE"
echo ""

# Export device type for use in main.sh
export DEVICE_TYPE

gum confirm "Continue with installation?" || return 1
