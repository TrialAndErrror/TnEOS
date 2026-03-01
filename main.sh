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
      if source ./steps/summary.sh; then
        CURRENT_STEP=4
        break
      else
        CURRENT_STEP=2  # Go back
      fi
      ;;
  esac
done

# Source installation modules
source ./install/install-yay.sh
source ./install/install-pacman-packages.sh
source ./install/install-nix-packages.sh
source ./install/copy-configs.sh
source ./install/setup-wallpaper.sh
source ./install/setup-lightdm-greeter.sh
source ./install/show-completion.sh

# Run installation steps
install_yay
install_pacman_packages
install_nix_packages
copy_configs
setup_wallpaper
setup_lightdm_greeter
show_completion
