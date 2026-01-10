#!/usr/bin/env bash
# Install packages via Nix
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

install_nix_packages() {
  if [ ${#NIX_PACKAGES[@]} -eq 0 ]; then
    echo "No Nix packages to install"
    return 0
  fi

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Nix Packages" "${#NIX_PACKAGES[@]} packages selected"

  echo "Installing: ${NIX_PACKAGES[*]}"
  echo ""

  # Install each package individually to handle errors better
  for pkg in "${NIX_PACKAGES[@]}"; do
    echo "  Installing $pkg..."
    NIXPKGS_ALLOW_UNFREE=1 nix --extra-experimental-features "nix-command flakes" profile add "nixpkgs#$pkg" --impure || {
      echo "  ⚠ Warning: Failed to install $pkg, skipping..."
    }
  done

  echo ""
  gum style --bold --foreground 2 "✓ Nix packages installation complete"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nix_packages
fi

