#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./state.sh
source ./ui.sh

# Source installation modules
source ./install/install-yay.sh
source ./install/install-pacman-packages.sh
source ./install/install-nix-packages.sh
source ./install/copy-configs.sh
source ./install/setup-wallpaper.sh
source ./install/setup-lightdm-greeter.sh
source ./install/show-completion.sh

run_full_install() {
  local CURRENT_STEP=1

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
          break
        else
          CURRENT_STEP=2  # Go back
        fi
        ;;
    esac
  done

  install_yay
  install_pacman_packages
  install_nix_packages
  copy_configs
  setup_wallpaper
  setup_lightdm_greeter
  show_completion
}

maintenance_install_configs() {
  DEVICE_TYPE=$(gum choose --header "Select your device type:" "Laptop" "Desktop")
  export DEVICE_TYPE

  # Include neovim by default so the nvim config is copied
  PACMAN_PACKAGES=(neovim)
  export PACMAN_PACKAGES

  copy_configs
}

maintenance_install_programs() {
  local CURRENT_STEP=1

  while true; do
    case $CURRENT_STEP in
      1)
        if source ./steps/admin.sh; then
          CURRENT_STEP=2
        else
          return 0  # User cancelled, return to maintenance menu
        fi
        ;;
      2)
        if source ./steps/programs.sh; then
          break
        else
          CURRENT_STEP=1  # Go back
        fi
        ;;
    esac
  done

  install_yay
  install_pacman_packages
  install_nix_packages
}

run_maintenance() {
  while true; do
    TASK=$(gum choose --header "Maintenance — select a task:" \
      "Install Configs" \
      "Install Programs" \
      "Exit") || break

    case "$TASK" in
      "Install Configs")
        maintenance_install_configs
        ;;
      "Install Programs")
        maintenance_install_programs
        ;;
      "Exit")
        break
        ;;
    esac
  done
}

# Entry point
MODE=$(gum choose --header "TnEOS Setup" \
  "Full Install" \
  "Maintenance")

case "$MODE" in
  "Full Install")
    run_full_install
    ;;
  "Maintenance")
    run_maintenance
    ;;
esac
