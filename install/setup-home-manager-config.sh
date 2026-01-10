#!/usr/bin/env bash
# Copy and configure Home Manager configuration files
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

setup_home_manager_config() {
  local REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  local HM_CONFIG_DIR="$HOME/.config/home-manager"

  echo "Setting up Home Manager configuration..."
  mkdir -p "$HM_CONFIG_DIR"

  # Copy the entire home-manager directory
  echo "Copying Home Manager configuration..."
  rsync -av "$REPO_DIR/home-manager/" "$HM_CONFIG_DIR/"
  echo ""

  # Conditionally remove nvim config if neovim wasn't selected
  if [[ ! " ${PACMAN_PACKAGES[@]} " =~ " neovim " ]]; then
    echo "Neovim not selected, removing nvim configuration from Home Manager..."
    # Remove the nvim config block from home.nix using markers
    sed -i '/# CONDITIONAL_NVIM_START/,/# CONDITIONAL_NVIM_END/d' "$HM_CONFIG_DIR/home.nix"
    # Also update the EDITOR variable
    sed -i 's/EDITOR = "nvim";/EDITOR = "vim";/' "$HM_CONFIG_DIR/home.nix"
  fi

  # Configure for Desktop vs Laptop mode
  if [ "$DEVICE_TYPE" = "Desktop" ]; then
    echo "Configuring for Desktop mode..."
    # Use desktop rc.lua (no battery widget)
    cp "$HM_CONFIG_DIR/config/awesome/rc.desktop.lua" "$HM_CONFIG_DIR/config/awesome/rc.lua"
    # Remove battery-widget directory
    rm -rf "$HM_CONFIG_DIR/config/awesome/battery-widget"
    echo "  ✓ Desktop configuration applied (no battery widget)"
  else
    echo "Configuring for Laptop mode..."
    # Use laptop rc.lua (with battery widget)
    cp "$HM_CONFIG_DIR/config/awesome/rc.laptop.lua" "$HM_CONFIG_DIR/config/awesome/rc.lua"
    echo "  ✓ Laptop configuration applied (with battery widget and brightness controls)"
  fi
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_home_manager_config
fi

