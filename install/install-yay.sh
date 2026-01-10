#!/usr/bin/env bash
# Install yay AUR helper if not already installed
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

install_yay() {
  if ! command -v yay &> /dev/null; then
    gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
      "Installing yay AUR Helper" \
      "yay is needed for AUR package support"

    echo "Installing yay..."
    echo ""

    # Install dependencies
    sudo pacman -S --needed --noconfirm git base-devel

    # Clone and build yay
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd -
    rm -rf "$TEMP_DIR"

    gum style --bold --foreground 2 "✓ yay installed successfully"
    echo ""
  else
    echo "✓ yay already installed"
    echo ""
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_yay
fi

