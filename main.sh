#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./state.sh
source ./ui.sh

# Source all install modules
source ./install/install-package-manager-packages.sh
source ./install/install-nix-packages.sh
source ./install/copy-configs.sh
source ./install/setup-wallpaper.sh
source ./install/setup-lightdm-greeter.sh
source ./install/show-completion.sh

# Prompt for device type if not already set
ensure_device_type() {
  if [ -z "${DEVICE_TYPE:-}" ]; then
    DEVICE_TYPE=$(gum choose --header "Select your device type:" "Laptop" "Desktop")
    export DEVICE_TYPE
  fi
}

# --- Actions ---

action_full_install() {
  local step=1
  while true; do
    case $step in
      1)
        if source ./steps/admin.sh; then
          step=2
        else
          return  # User cancelled
        fi
        ;;
      2)
        if source ./steps/programs.sh; then
          step=3
        else
          step=1
        fi
        ;;
      3)
        if source ./steps/summary.sh; then
          break
        else
          step=2
        fi
        ;;
    esac
  done

  install_package_manager_packages
  install_nix_packages
  copy_configs
  setup_wallpaper
  setup_lightdm_greeter
  show_completion
}

action_install_config() {
  ensure_device_type

  if gum confirm "Include Neovim config?"; then
    PACMAN_PACKAGES=(neovim)
  else
    PACMAN_PACKAGES=()
  fi

  copy_configs
}

action_install_programs() {
  ensure_device_type

  if source ./steps/programs.sh; then
    install_package_manager_packages
    install_nix_packages
  fi
}

action_setup_display() {
  setup_wallpaper
  setup_lightdm_greeter
}

action_restore_backup() {
  bash "$(dirname "$0")/restore-backup.sh" || true
}

action_install_fonts() {
  bash "$(dirname "$0")/install-fonts.sh" || true
}

# --- Main Menu ---

gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "TnEOS" "Arch Linux Configuration Manager"

while true; do
  echo ""
  CHOICE=$(gum choose \
    --header "What would you like to do?" \
    --height 10 \
    "Install Everything" \
    "Install Config Files" \
    "Install Programs" \
    "Setup Display" \
    "Restore Backup" \
    "Install Fonts" \
    "Quit")

  echo ""
  case "$CHOICE" in
    "Install Everything")   action_full_install ;;
    "Install Config Files") action_install_config ;;
    "Install Programs")     action_install_programs ;;
    "Setup Display")        action_setup_display ;;
    "Restore Backup")       action_restore_backup ;;
    "Install Fonts")        action_install_fonts ;;
    "Quit")                 exit 0 ;;
  esac

  echo ""
  gum confirm "Return to main menu?" || break
done
