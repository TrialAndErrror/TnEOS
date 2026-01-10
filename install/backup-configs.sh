#!/usr/bin/env bash
# Backup existing configuration files
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

# Export BACKUP_DIR so it can be used by other scripts
export BACKUP_DIR="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"
export BACKUP_NEEDED=false

backup_configs() {
  local CONFIGS_TO_BACKUP=("awesome" "nvim" "picom" "rofi" "alacritty")

  echo "Checking for existing configuration files..."
  for config in "${CONFIGS_TO_BACKUP[@]}"; do
    if [ -e "$HOME/.config/$config" ]; then
      BACKUP_NEEDED=true
      break
    fi
  done

  if [ "$BACKUP_NEEDED" = true ]; then
    gum style --bold --foreground 3 "⚠ Existing config files detected"
    if gum confirm "Backup existing config files to $BACKUP_DIR?"; then
      mkdir -p "$BACKUP_DIR"
      echo "Backing up existing configurations..."

      for config in "${CONFIGS_TO_BACKUP[@]}"; do
        if [ -e "$HOME/.config/$config" ]; then
          echo "  Backing up ~/.config/$config"
          mv "$HOME/.config/$config" "$BACKUP_DIR/"
        fi
      done

      gum style --bold --foreground 2 "✓ Backup created at: $BACKUP_DIR"
      echo ""
    else
      gum style --bold --foreground 1 "⚠ Warning: Existing files will be overwritten!"
      gum confirm "Continue anyway?" || exit 1
    fi
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  backup_configs
fi

