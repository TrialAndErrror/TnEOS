#!/usr/bin/env bash
# Copy TnEOS config files to ~/.config/, backing up any existing files
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

# Copy a directory config to ~/.config/, with diff checking.
# Args: src_dir dest_dir display_name
_install_dir_config() {
  local src="$1" dest="$2" name="$3"

  if [ ! -d "$src" ]; then
    echo "  ⚠ Source not found: $src, skipping..."
    return
  fi

  if [ -e "$dest" ]; then
    if diff -rq "$src" "$dest" &>/dev/null; then
      echo "  ✓ $name is already up to date, skipping."
      return
    fi

    echo ""
    gum style --bold --foreground 212 "Changes detected in $name:"
    diff -r --color=always "$dest" "$src" || true
    echo ""

    if ! gum confirm "Overwrite ~/.config/$name with the repo version?"; then
      echo "  Skipping $name."
      return
    fi

    local backup="${dest}.bak"
    if [ -e "$backup" ]; then
      backup="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
    fi
    echo "  Backing up ~/.config/$name -> ${backup##*/home/$USER/.config/}"
    mv "$dest" "$backup"
  fi

  echo "  Copying $name..."
  cp -r "$src" "$dest"
}

# Copy a single file config (e.g. ~/.zshrc), with diff checking.
# Args: src_file dest_file display_name
_install_file_config() {
  local src="$1" dest="$2" name="$3"

  if [ ! -f "$src" ]; then
    echo "  ⚠ Source not found: $src, skipping..."
    return
  fi

  if [ -e "$dest" ]; then
    if diff -q "$src" "$dest" &>/dev/null; then
      echo "  ✓ $name is already up to date, skipping."
      return
    fi

    echo ""
    gum style --bold --foreground 212 "Changes detected in $name:"
    diff --color=always "$dest" "$src" || true
    echo ""

    if ! gum confirm "Overwrite ~/$name with the repo version?"; then
      echo "  Skipping $name."
      return
    fi

    local backup="${dest}.bak"
    if [ -e "$backup" ]; then
      backup="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
    fi
    echo "  Backing up ~/$name -> ${backup##*/home/$USER/}"
    mv "$dest" "$backup"
  fi

  echo "  Copying $name..."
  cp "$src" "$dest"
}

copy_configs() {
  local REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  local CONFIG_SRC="$REPO_DIR/config"
  local CONFIG_DEST="$HOME/.config"

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Copying Configuration Files" "Installing dotfiles to ~/.config/"

  # Determine which configs to install
  local CONFIGS=("awesome" "picom" "rofi" "alacritty" "ghostty")

  if [[ " ${PACMAN_PACKAGES[@]} " =~ " neovim " ]]; then
    CONFIGS+=("nvim")
  fi

  # Prepare awesome config for desktop/laptop
  local AWESOME_SRC="$CONFIG_SRC/awesome"
  if [ "$DEVICE_TYPE" = "Desktop" ]; then
    echo "Preparing awesome config for Desktop (no battery widget)..."
    rm -rf "$AWESOME_SRC/battery-widget"
  else
    echo "Preparing awesome config for Laptop (with battery widget)..."
    cp "$AWESOME_SRC/modules/config.laptop.lua" "$AWESOME_SRC/modules/config.lua"
  fi
  echo ""

  echo "Installing configs to $CONFIG_DEST..."
  for config in "${CONFIGS[@]}"; do
    _install_dir_config "$CONFIG_SRC/$config" "$CONFIG_DEST/$config" "$config"
  done

  _install_file_config "$CONFIG_SRC/.zshrc" "$HOME/.zshrc" ".zshrc"

  echo ""
  gum style --bold --foreground 2 "✓ Configs installed to ~/.config/ and ~/"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  copy_configs
fi
