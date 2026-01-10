#!/usr/bin/env bash
# Install Home Manager if not already installed
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

install_home_manager() {
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Setting up Home Manager" "Installing and configuring dotfile management"

  if ! command -v home-manager &> /dev/null; then
    echo "Installing Home Manager..."
    echo "Adding Home Manager channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

    echo "Updating Nix channels..."
    nix-channel --update

    echo "Installing Home Manager package..."
    nix-shell '<home-manager>' -A install

    echo ""
  else
    echo "Home Manager already installed"
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_home_manager
fi

