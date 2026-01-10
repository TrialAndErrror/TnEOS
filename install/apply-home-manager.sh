#!/usr/bin/env bash
# Apply Home Manager configuration
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

apply_home_manager() {
  echo "Applying Home Manager configuration..."
  home-manager switch

  # Fix ownership of config files (Home Manager might create files as root)
  echo "Fixing ownership of configuration files..."
  chown -R "$USER:$USER" "$HOME/.config"
  echo "✓ Configuration file ownership corrected"

  echo ""
  gum style --bold --foreground 2 "✓ Home Manager configured successfully"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  apply_home_manager
fi

