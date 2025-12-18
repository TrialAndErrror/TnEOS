#!/usr/bin/env bash
set -euo pipefail

source ./ui.sh
source ./state.sh

THEME=$(radiolist "Theme Selection" "Choose a theme:" \
  dark  "Dark (default)" on \
  light "Light" off \
  kids  "Kids" off
)
