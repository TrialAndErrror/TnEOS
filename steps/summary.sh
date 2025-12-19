#!/usr/bin/env bash
set -euo pipefail

source ./ui.sh

SUMMARY=$(
  cat <<EOF
Hostname: $HOSTNAME
User: $USERNAME
Theme: $THEME

Pacman packages:
  ${PACMAN_PACKAGES[*]:-(none)}

Nix packages:
  ${NIX_PACKAGES[*]:-(none)}
EOF
)

dialog --title "Summary" --yesno "$SUMMARY

Proceed with installation?" 20 70

case $? in
  0) ;;
  *) exit 1 ;;
esac
