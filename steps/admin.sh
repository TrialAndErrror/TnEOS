#!/usr/bin/env bash
set -e

source ./ui.sh

# Get current system info (already set during Arch install)
HOSTNAME=$(hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "unknown")
USERNAME=$USER

# --- Verify distro detection ---
if [ -z "${DISTRO_TYPE:-}" ]; then
  gum style --bold --foreground 3 "Could not detect Linux distribution."
  DISTRO_TYPE=$(gum choose --header "Select your distribution:" "Arch" "Debian" "Fedora")
  export DISTRO_TYPE
fi

ensure_device_type

export DISTRO_TYPE

gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "System Information" \
  "Hostname:    $HOSTNAME" \
  "User:        $USERNAME" \
  "Distro:      $DISTRO_TYPE (detected)" \
  "Device type: $DEVICE_TYPE (detected)" \
  "" \
  "Edit these above if incorrect before continuing."

echo ""

gum confirm "Continue with installation?" || return 1
