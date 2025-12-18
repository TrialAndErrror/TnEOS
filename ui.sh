#!/usr/bin/env bash
set -euo pipefail

DIALOG=${DIALOG:-dialog}

input() {
  local title=$1
  local prompt=$2
  $DIALOG --stdout --title "$title" \
    --inputbox "$prompt" 10 50
}

password() {
  local title=$1
  local prompt=$2
  $DIALOG --stdout --title "$title" \
    --passwordbox "$prompt" 10 50
}

menu() {
  local title=$1
  local prompt=$2
  shift 2
  $DIALOG --stdout --title "$title" \
    --menu "$prompt" 15 60 6 "$@"
}

checklist() {
  local title=$1
  local prompt=$2
  shift 2
  $DIALOG --stdout --title "$title" \
    --checklist "$prompt" 15 60 8 "$@"
}

radiolist() {
  local title=$1
  local prompt=$2
  shift 2
  $DIALOG --stdout --title "$title" \
    --radiolist "$prompt" 15 60 6 "$@"
}

msgbox() {
  $DIALOG --title "$1" --msgbox "$2" 10 50
}
