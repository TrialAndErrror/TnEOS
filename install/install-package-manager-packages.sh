#!/usr/bin/env bash
# Install packages via pacman/apt/dnf
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

install_package_manager_packages() {
  if [ ${#PACMAN_PACKAGES[@]} -eq 0 ]; then
    echo "No packages to install"
    return 0
  fi

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Packages" "${#PACMAN_PACKAGES[@]} packages selected"

  echo "Installing: ${PACMAN_PACKAGES[*]}"
  echo ""
  case "${DISTRO_TYPE:-Arch}" in
    Debian) sudo apt install -y "${PACMAN_PACKAGES[@]}" ;;
    Fedora) sudo dnf install -y "${PACMAN_PACKAGES[@]}" ;;
    *)      sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}" ;;
  esac

  echo ""
  gum style --bold --foreground 2 "✓ Packages installed successfully"
  echo ""

  # Enable LightDM if it was installed
  if [[ " ${PACMAN_PACKAGES[@]} " =~ " lightdm " ]]; then
    echo "Enabling LightDM display manager..."
    sudo systemctl enable lightdm.service
    gum style --bold --foreground 2 "✓ LightDM enabled - will start on next boot"
    echo ""
  fi

  # Enable acpid for battery widget support
  if [[ " ${PACMAN_PACKAGES[@]} " =~ " acpid " ]]; then
    echo "Enabling acpid for battery monitoring..."
    sudo systemctl enable --now acpid.service
    gum style --bold --foreground 2 "✓ acpid enabled - battery widget will work"
    echo ""
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_package_manager_packages
fi

