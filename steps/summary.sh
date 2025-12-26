#!/usr/bin/env bash
set -e

source ./ui.sh

# Build bulleted lists
PACMAN_LIST=""
if [ ${#PACMAN_PACKAGES[@]} -eq 0 ]; then
  PACMAN_LIST="  (none)"
else
  for pkg in "${PACMAN_PACKAGES[@]}"; do
    PACMAN_LIST+="  • $pkg"$'\n'
  done
fi

NIX_LIST=""
if [ ${#NIX_PACKAGES[@]} -eq 0 ]; then
  NIX_LIST="  (none)"
else
  for pkg in "${NIX_PACKAGES[@]}"; do
    NIX_LIST+="  • $pkg"$'\n'
  done
fi

SUMMARY=$(
  cat <<EOF
System: $USERNAME@$HOSTNAME

Pacman packages:
$PACMAN_LIST
Nix packages:
$NIX_LIST
Home Manager: Yes (automatic)
EOF
)

gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" "Summary"
echo "$SUMMARY"
echo ""
gum confirm "Proceed with installation?" || return 1
