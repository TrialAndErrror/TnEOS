#!/usr/bin/env bash
# Install Nerd Fonts from GitHub releases (works on all distros)
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

FONTS_DIR="$HOME/.local/share/fonts/NerdFonts"
RELEASE_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

# Release archive name → display name
declare -A NERD_FONTS=(
  ["JetBrainsMono"]="JetBrains Mono"
  ["FiraCode"]="FiraCode"
  ["Hack"]="Hack"
  ["Meslo"]="MesloLG"
  ["SourceCodePro"]="Source Code Pro"
  ["Iosevka"]="Iosevka"
  ["CascadiaCode"]="Cascadia Code"
  ["UbuntuMono"]="Ubuntu Mono"
  ["RobotoMono"]="Roboto Mono"
  ["DejaVuSansMono"]="DejaVu Sans Mono"
)

font_installed() {
  [ -d "$FONTS_DIR/$1" ]
}

install_nerd_fonts() {
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Nerd Fonts Installation" \
    "Fonts downloaded from github.com/ryanoasis/nerd-fonts"

  echo ""

  # Build checklist — pre-select already installed fonts
  local checklist_options=()
  for key in "${!NERD_FONTS[@]}"; do
    local status="off"
    font_installed "$key" && status="on"
    checklist_options+=("$key" "${NERD_FONTS[$key]}" "$status")
  done

  local FONT_SELECTION
  FONT_SELECTION=$(checklist "Nerd Fonts" "Select fonts to install:" \
    "${checklist_options[@]}") || {
    echo "No fonts selected, skipping..."
    return 0
  }

  # Skip any that are already installed
  local FONTS_TO_INSTALL=()
  for font in $FONT_SELECTION; do
    font_installed "$font" || FONTS_TO_INSTALL+=("$font")
  done

  if [ ${#FONTS_TO_INSTALL[@]} -eq 0 ]; then
    echo "All selected fonts are already installed."
    return 0
  fi

  mkdir -p "$FONTS_DIR"

  local TEMP_DIR
  TEMP_DIR=$(mktemp -d)
  trap "rm -rf '$TEMP_DIR'" EXIT

  for font in "${FONTS_TO_INSTALL[@]}"; do
    echo "Downloading $font..."
    if curl -fL --progress-bar "$RELEASE_URL/$font.tar.xz" -o "$TEMP_DIR/$font.tar.xz"; then
      mkdir -p "$FONTS_DIR/$font"
      tar -xf "$TEMP_DIR/$font.tar.xz" -C "$FONTS_DIR/$font"
      gum style --foreground 2 "  ✓ ${NERD_FONTS[$font]} installed"
    else
      gum style --foreground 1 "  ✗ Failed to download $font"
    fi
  done

  echo ""
  echo "Refreshing font cache..."
  fc-cache -fv
  echo ""

  gum style --bold --foreground 2 "✓ Nerd Fonts installed successfully"
  echo ""

  if gum confirm "Would you like to set a default Nerd Font for your configs?"; then
    set_default_font "${FONTS_TO_INSTALL[@]}"
  fi
}

set_default_font() {
  local installed_fonts=("$@")

  echo ""
  gum style --bold --foreground 212 "Select Default Nerd Font"
  echo "This will update Alacritty, Rofi, and AwesomeWM configs"
  echo ""

  local font_options=()
  for key in "${installed_fonts[@]}"; do
    font_options+=("${NERD_FONTS[$key]} Nerd Font")
  done

  local selected_font
  selected_font=$(gum choose --header "Select default font:" "${font_options[@]}") || {
    echo "No font selected, keeping current configuration"
    return 0
  }

  echo ""
  echo "Setting default font to: $selected_font"
  echo ""

  local CONFIG_DIR="$HOME/.config"

  if [ -f "$CONFIG_DIR/alacritty/alacritty.toml" ]; then
    echo "Updating Alacritty configuration..."
    sed -i "s/family = \".*Nerd Font\"/family = \"$selected_font\"/" \
      "$CONFIG_DIR/alacritty/alacritty.toml"
  fi

  if [ -f "$CONFIG_DIR/awesome/theme.lua" ]; then
    echo "Updating AwesomeWM theme..."
    sed -i "s/theme.font.*=.*\".*Nerd Font.*/theme.font          = \"$selected_font 12\"/" \
      "$CONFIG_DIR/awesome/theme.lua"
  fi

  if [ -d "$CONFIG_DIR/rofi" ]; then
    echo "Updating Rofi configurations..."
    find "$CONFIG_DIR/rofi" -name "*.rasi" -type f -exec \
      sed -i "s/font:.*\".*Nerd Font.*/font: \"$selected_font 10\";/" {} \;
  fi

  echo ""
  gum style --bold --foreground 2 "✓ Default font updated in configuration files"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nerd_fonts
fi
