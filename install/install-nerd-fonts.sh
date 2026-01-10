#!/usr/bin/env bash
# Install Nerd Fonts and optionally set one as default
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

# Popular Nerd Fonts available in AUR
declare -A NERD_FONTS=(
  ["ttf-jetbrains-mono-nerd"]="JetBrainsMono Nerd Font"
  ["ttf-firacode-nerd"]="FiraCode Nerd Font"
  ["ttf-hack-nerd"]="Hack Nerd Font"
  ["ttf-meslo-nerd"]="MesloLG Nerd Font"
  ["ttf-sourcecodepro-nerd"]="SauceCodePro Nerd Font"
  ["ttf-iosevka-nerd"]="Iosevka Nerd Font"
  ["ttf-cascadia-code-nerd"]="CaskaydiaCove Nerd Font"
  ["ttf-ubuntu-mono-nerd"]="UbuntuMono Nerd Font"
  ["ttf-roboto-mono-nerd"]="RobotoMono Nerd Font"
  ["ttf-dejavu-nerd"]="DejaVuSansMono Nerd Font"
)

install_nerd_fonts() {
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Nerd Fonts Installation" \
    "Select Nerd Fonts to install"

  echo ""
  echo "Available Nerd Fonts:"
  echo ""

  # Build checklist options
  local checklist_options=()
  for pkg in "${!NERD_FONTS[@]}"; do
    local font_name="${NERD_FONTS[$pkg]}"
    # Check if already installed
    local status="off"
    if pacman -Qi "$pkg" &>/dev/null; then
      status="on"
    fi
    checklist_options+=("$pkg" "$font_name" "$status")
  done

  # Let user select fonts
  local FONT_SELECTION
  FONT_SELECTION=$(checklist "Nerd Fonts" "Select fonts to install (already installed fonts are pre-selected):" \
    "${checklist_options[@]}") || {
    echo "No fonts selected, skipping..."
    return 0
  }

  # Convert selection to array
  local FONTS_TO_INSTALL=()
  for font in $FONT_SELECTION; do
    FONTS_TO_INSTALL+=("$font")
  done

  if [ ${#FONTS_TO_INSTALL[@]} -eq 0 ]; then
    echo "No fonts selected, skipping..."
    return 0
  fi

  # Install selected fonts (Nerd Fonts are in official repos, use pacman)
  echo "Installing selected Nerd Fonts..."
  echo ""
  sudo pacman -S --needed --noconfirm "${FONTS_TO_INSTALL[@]}"

  echo ""
  gum style --bold --foreground 2 "✓ Nerd Fonts installed successfully"
  echo ""

  # Refresh font cache
  echo "Refreshing font cache..."
  fc-cache -fv
  echo ""

  # Ask if user wants to set a default font
  if gum confirm "Would you like to set a default Nerd Font for your system?"; then
    set_default_font "${FONTS_TO_INSTALL[@]}"
  fi
}

set_default_font() {
  local installed_fonts=("$@")
  
  echo ""
  gum style --bold --foreground 212 "Select Default Nerd Font"
  echo "This will update Alacritty, Rofi, and AwesomeWM configs"
  echo ""

  # Build list of installed font names
  local font_options=()
  for pkg in "${installed_fonts[@]}"; do
    font_options+=("${NERD_FONTS[$pkg]}")
  done

  # Let user choose default font
  local selected_font
  selected_font=$(gum choose --header "Select default font:" "${font_options[@]}") || {
    echo "No font selected, keeping current configuration"
    return 0
  }

  echo ""
  echo "Setting default font to: $selected_font"
  echo ""

  # Update configuration files
  local HM_CONFIG_DIR="$HOME/.config/home-manager"
  
  if [ -d "$HM_CONFIG_DIR" ]; then
    # Update Alacritty config
    if [ -f "$HM_CONFIG_DIR/config/alacritty/alacritty.toml" ]; then
      echo "Updating Alacritty configuration..."
      sed -i "s/family = \".*Nerd Font\"/family = \"$selected_font\"/" \
        "$HM_CONFIG_DIR/config/alacritty/alacritty.toml"
    fi

    # Update AwesomeWM theme
    if [ -f "$HM_CONFIG_DIR/config/awesome/theme.lua" ]; then
      echo "Updating AwesomeWM theme..."
      sed -i "s/theme.font.*=.*\".*Nerd Font.*/theme.font          = \"$selected_font 12\"/" \
        "$HM_CONFIG_DIR/config/awesome/theme.lua"
    fi

    # Update Rofi font configs
    echo "Updating Rofi configurations..."
    find "$HM_CONFIG_DIR/config/rofi" -name "*.rasi" -type f -exec \
      sed -i "s/font:.*\".*Nerd Font.*/font: \"$selected_font 10\";/" {} \;

    echo ""
    gum style --bold --foreground 2 "✓ Default font updated in configuration files"
    echo ""
    
    # Apply changes with home-manager if available
    if command -v home-manager &> /dev/null; then
      if gum confirm "Apply changes now with home-manager switch?"; then
        echo "Applying Home Manager configuration..."
        home-manager switch
        echo ""
        gum style --bold --foreground 2 "✓ Changes applied successfully"
      else
        echo ""
        gum style --bold --foreground 3 "⚠ Remember to run 'home-manager switch' to apply changes"
      fi
    fi
  else
    gum style --bold --foreground 3 "⚠ Home Manager config directory not found at $HM_CONFIG_DIR"
    echo "Font installed but configuration not updated"
  fi

  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_nerd_fonts
fi

