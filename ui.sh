#!/usr/bin/env bash
set -euo pipefail

GUM=${GUM:-gum}

input() {
  local title=$1
  local prompt=$2
  $GUM style --bold --foreground 212 "$title" >&2
  $GUM input --placeholder "$prompt" --width 50
}

password() {
  local title=$1
  local prompt=$2
  $GUM style --bold --foreground 212 "$title" >&2
  $GUM input --password --placeholder "$prompt" --width 50
}

menu() {
  local title=$1
  local prompt=$2
  shift 2
  $GUM style --bold --foreground 212 "$title" >&2
  echo "$prompt" >&2

  # Convert dialog menu format to gum choose format
  local options=()
  while [ $# -gt 0 ]; do
    options+=("$1 - $2")
    shift 2
  done

  $GUM choose "${options[@]}" | cut -d' ' -f1
}

checklist() {
  local title=$1
  local prompt=$2
  shift 2
  $GUM style --bold --foreground 212 "$title" >&2
  echo "$prompt" >&2

  # Convert dialog checklist format to gum choose format
  local options=()
  local selected=()
  while [ $# -gt 0 ]; do
    local item=$1
    local desc=$2
    local status=$3
    options+=("$item")
    if [ "$status" = "on" ]; then
      selected+=("$item")
    fi
    shift 3
  done

  # Build the gum choose command with selected items (comma-separated)
  if [ ${#selected[@]} -gt 0 ]; then
    # Join selected items with commas
    local IFS=','
    $GUM choose --no-limit --height 15 --selected="${selected[*]}" "${options[@]}"
  else
    $GUM choose --no-limit --height 15 "${options[@]}"
  fi
}

radiolist() {
  local title=$1
  local prompt=$2
  shift 2
  $GUM style --bold --foreground 212 "$title" >&2
  echo "$prompt" >&2

  # Convert dialog radiolist format to gum choose format
  local options=()
  while [ $# -gt 0 ]; do
    options+=("$1")
    shift 3  # Skip description and status
  done

  $GUM choose --height 10 "${options[@]}"
}

msgbox() {
  local title=$1
  local message=$2
  $GUM style --bold --foreground 212 --border double --padding "1 2" --margin "1" "$title"
  echo "$message"
  $GUM input --placeholder "Press Enter to continue..." --width 0 > /dev/null
}
