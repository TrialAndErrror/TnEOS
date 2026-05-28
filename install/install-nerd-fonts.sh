#!/usr/bin/env bash
# Install Nerd Fonts bundled with TnEOS
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

FONTS_DIR="$HOME/.local/share/fonts/NerdFonts"
REPO_FONTS_DIR="$SCRIPT_DIR/../fonts"

declare -A NERD_FONTS=(
  ["JetBrainsMonoNLNerdFont-Regular.ttf"]="JetBrains Mono"
  ["FiraCodeNerdFont-Regular.ttf"]="FiraCode"
  ["HackNerdFont-Regular.ttf"]="Hack"
  ["MesloLGLNerdFont-Regular.ttf"]="MesloLG"
  ["SauceCodeProNerdFont-Regular.ttf"]="Source Code Pro"
  ["IosevkaNerdFont-Regular.ttf"]="Iosevka"
  ["CaskaydiaCoveNerdFont-Regular.ttf"]="Cascadia Code"
  ["UbuntuMonoNerdFont-Regular.ttf"]="Ubuntu Mono"
  ["RobotoMonoNerdFont-Regular.ttf"]="Roboto Mono"
  ["DejaVuSansMNerdFont-Regular.ttf"]="DejaVu Sans Mono"
)

font_installed() {
  [ -f "$FONTS_DIR/$1" ]
}

install_nerd_fonts() {
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Nerd Fonts Installation" \
    "Fonts bundled with TnEOS"

  echo ""

  local checklist_options=()
  for file in "${!NERD_FONTS[@]}"; do
    local label="${NERD_FONTS[$file]}"
    font_installed "$file" && label="$label (installed)"
    checklist_options+=("$file" "$label" "on")
  done

  local FONT_SELECTION
  FONT_SELECTION=$(checklist "Nerd Fonts" "Select fonts to install:" \
    "${checklist_options[@]}") || {
    echo "No fonts selected, skipping..."
    return 0
  }

  local FONTS_TO_INSTALL=()
  for font in $FONT_SELECTION; do
    font_installed "$font" || FONTS_TO_INSTALL+=("$font")
  done

  if [ ${#FONTS_TO_INSTALL[@]} -eq 0 ]; then
    echo "All selected fonts are already installed."
    return 0
  fi

  mkdir -p "$FONTS_DIR"

  for font in "${FONTS_TO_INSTALL[@]}"; do
    echo "Installing $font..."
    cp "$REPO_FONTS_DIR/$font" "$FONTS_DIR/$font"
    gum style --foreground 2 "  ✓ ${NERD_FONTS[$font]} installed"
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
  for file in "${installed_fonts[@]}"; do
    font_options+=("${NERD_FONTS[$file]} Nerd Font")
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
