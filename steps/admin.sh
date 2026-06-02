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

# --- Detect laptop vs desktop via battery presence ---
if [ -z "${DEVICE_TYPE:-}" ]; then
  for supply_type in /sys/class/power_supply/*/type; do
    if [ -f "$supply_type" ] && grep -qi "^battery$" "$supply_type" 2>/dev/null; then
      DEVICE_TYPE="Laptop"
      break
    fi
  done

  if [ -z "$DEVICE_TYPE" ]; then
    gum style --bold --foreground 3 "Could not detect device type (no battery found)."
    DEVICE_TYPE=$(gum choose --header "Select your device type:" "Desktop" "Laptop")
  fi
fi

export DISTRO_TYPE
export DEVICE_TYPE

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
