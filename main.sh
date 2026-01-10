#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./state.sh
source ./ui.sh

# Step navigation
CURRENT_STEP=1

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
      if source ./steps/homemanager.sh; then
        CURRENT_STEP=4
      else
        CURRENT_STEP=2  # Go back
      fi
      ;;
    4)
      if source ./steps/summary.sh; then
        CURRENT_STEP=5
        break
      else
        CURRENT_STEP=3  # Go back
      fi
      ;;
  esac
done

# Source installation modules
source ./install/install-yay.sh
source ./install/install-pacman-packages.sh
source ./install/install-nix-packages.sh
source ./install/install-home-manager.sh
source ./install/backup-configs.sh
source ./install/setup-home-manager-config.sh
source ./install/apply-home-manager.sh
source ./install/setup-wallpaper.sh
source ./install/setup-lightdm-greeter.sh
source ./install/show-completion.sh

# Run installation steps
install_yay
install_pacman_packages
install_nix_packages
install_home_manager
backup_configs
setup_home_manager_config
apply_home_manager
setup_wallpaper
setup_lightdm_greeter
show_completion
