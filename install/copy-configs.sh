#!/usr/bin/env bash
# Copy TnEOS config files to ~/.config/, backing up any existing files
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

copy_configs() {
  local REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  local CONFIG_SRC="$REPO_DIR/config"
  local CONFIG_DEST="$HOME/.config"

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Copying Configuration Files" "Installing dotfiles to ~/.config/"

  # Determine which configs to install
  local CONFIGS=("awesome" "picom" "rofi" "alacritty")

  if [[ " ${PACMAN_PACKAGES[@]} " =~ " neovim " ]]; then
    CONFIGS+=("nvim")
  fi

  # Prepare awesome config for desktop/laptop
  local AWESOME_SRC="$CONFIG_SRC/awesome"
  if [ "$DEVICE_TYPE" = "Desktop" ]; then
    echo "Preparing awesome config for Desktop (no battery widget)..."
    cp "$AWESOME_SRC/rc.desktop.lua" "$AWESOME_SRC/rc.lua"
    rm -rf "$AWESOME_SRC/battery-widget"
  else
    echo "Preparing awesome config for Laptop (with battery widget)..."
    cp "$AWESOME_SRC/rc.laptop.lua" "$AWESOME_SRC/rc.lua"
  fi
  echo ""

  # Copy each config, backing up existing ones
  echo "Installing configs to $CONFIG_DEST..."
  for config in "${CONFIGS[@]}"; do
    local src="$CONFIG_SRC/$config"
    local dest="$CONFIG_DEST/$config"

    if [ ! -d "$src" ]; then
      echo "  ⚠ Source not found: $src, skipping..."
      continue
    fi

    if [ -e "$dest" ]; then
      local backup="${dest}.bak"
      # If .bak already exists, use a timestamp
      if [ -e "$backup" ]; then
        backup="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
      fi
      echo "  Backing up existing ~/.config/$config -> ${backup##*/home/$USER/.config/}"
      mv "$dest" "$backup"
    fi

    echo "  Copying $config..."
    cp -r "$src" "$dest"
  done

  echo ""
  gum style --bold --foreground 2 "✓ Configs installed to ~/.config/"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  copy_configs
fi
