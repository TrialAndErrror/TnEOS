#!/usr/bin/env bash
# Install packages via pacman/apt/dnf
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

# Translate Arch package names to apt equivalents, skipping unavailable ones
translate_packages_apt() {
  local translated=()
  for pkg in "$@"; do
    case $pkg in
      7zip)                   translated+=(p7zip-full) ;;
      go)                     translated+=(golang) ;;
      python)                 translated+=(python3) ;;
      libreoffice-fresh)      translated+=(libreoffice) ;;
      docker)                 translated+=(docker.io) ;;
      imagemagick)            translated+=(imagemagick) ;;
      yazi)                   echo "  ⚠ Skipping yazi: not in apt repos (install manually from yazi-rs.github.io)" ;;
      *)                      translated+=("$pkg") ;;
    esac
  done
  echo "${translated[@]}"
}

# Translate Arch package names to dnf equivalents, skipping unavailable ones
translate_packages_dnf() {
  local translated=()
  for pkg in "$@"; do
    case $pkg in
      7zip)                   translated+=(p7zip p7zip-plugins) ;;
      go)                     translated+=(golang) ;;
      python)                 translated+=(python3) ;;
      libreoffice-fresh)      translated+=(libreoffice) ;;
      imagemagick)            translated+=(ImageMagick) ;;
      yazi) echo "  ⚠ Skipping yazi: not in dnf repos (install manually from yazi-rs.github.io)" ;;
      yazi)                   echo "  ⚠ Skipping yazi: not in dnf repos (install manually from yazi-rs.github.io)" ;;
      *)                      translated+=("$pkg") ;;
    esac
  done
  echo "${translated[@]}"
}

install_package_manager_packages() {
  if [ ${#PACMAN_PACKAGES[@]} -eq 0 ]; then
    echo "No packages to install"
    return 0
  fi

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Packages" "${#PACMAN_PACKAGES[@]} packages selected"

  echo ""
  case "${DISTRO_TYPE:-Arch}" in
    Debian)
      local pkgs
      pkgs=($(translate_packages_apt "${PACMAN_PACKAGES[@]}"))
      echo "Installing via apt: ${pkgs[*]}"
      echo ""
      sudo apt install -y "${pkgs[@]}"
      ;;
    Fedora)
      local pkgs
      pkgs=($(translate_packages_dnf "${PACMAN_PACKAGES[@]}"))
      echo "Installing via dnf: ${pkgs[*]}"
      echo ""
      sudo dnf install -y "${pkgs[@]}"
      ;;
    *)
      echo "Installing via pacman: ${PACMAN_PACKAGES[*]}"
      echo ""
      sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
      ;;
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

