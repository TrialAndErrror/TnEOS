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

# Install Pacman packages
if [ ${#PACMAN_PACKAGES[@]} -gt 0 ]; then
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Pacman Packages" "${#PACMAN_PACKAGES[@]} packages selected"

  echo "Installing: ${PACMAN_PACKAGES[*]}"
  gum spin --spinner dot --title "Installing Pacman packages..." -- \
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

  gum style --bold --foreground 2 "✓ Pacman packages installed successfully"
  echo ""
fi

# Install Nix packages
if [ ${#NIX_PACKAGES[@]} -gt 0 ]; then
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Nix Packages" "${#NIX_PACKAGES[@]} packages selected"

  echo "Installing: ${NIX_PACKAGES[*]}"
  gum spin --spinner dot --title "Installing Nix packages..." -- \
    nix profile install "${NIX_PACKAGES[@]/#/nixpkgs#}"

  gum style --bold --foreground 2 "✓ Nix packages installed successfully"
  echo ""
fi

gum style --bold --foreground 2 --border double --padding "1 2" --margin "1" \
  "Installation Complete!" "All packages have been installed successfully."
