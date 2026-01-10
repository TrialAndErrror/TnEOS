#!/usr/bin/env bash
# Install and configure TnEOS wallpaper
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

setup_wallpaper() {
  local REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  local HM_CONFIG_DIR="$HOME/.config/home-manager"

  # Copy TnEOS wallpaper (don't overwrite existing wallpapers)
  echo "Installing TnEOS wallpaper..."
  mkdir -p "$HOME/Pictures/Wallpapers"

  # Try to find wallpaper in either the copied config or the source repo
  local WALLPAPER_SOURCE=""
  if [ -f "$HM_CONFIG_DIR/assets/backgrounds/wallpaper.jpg" ]; then
    WALLPAPER_SOURCE="$HM_CONFIG_DIR/assets/backgrounds/wallpaper.jpg"
  elif [ -f "$REPO_DIR/home-manager/assets/backgrounds/wallpaper.jpg" ]; then
    WALLPAPER_SOURCE="$REPO_DIR/home-manager/assets/backgrounds/wallpaper.jpg"
  fi

  if [ -n "$WALLPAPER_SOURCE" ]; then
    cp -n "$WALLPAPER_SOURCE" "$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg"
    echo "  ✓ TnEOS wallpaper added to ~/Pictures/Wallpapers/"
  else
    echo "  ⚠ Warning: TnEOS wallpaper not found, skipping..."
  fi
  echo ""

  # Configure nitrogen to use the TnEOS wallpaper
  # Check if nitrogen is installed (either in PACMAN_PACKAGES or already on system)
  local CONFIGURE_NITROGEN=false
  if [[ " ${PACMAN_PACKAGES[@]} " =~ " nitrogen " ]] || command -v nitrogen &> /dev/null; then
    CONFIGURE_NITROGEN=true
  fi

  if [ "$CONFIGURE_NITROGEN" = true ]; then
    echo "Configuring nitrogen wallpaper..."
    mkdir -p "$HOME/.config/nitrogen"

    # Create nitrogen config with the wallpaper
    cat > "$HOME/.config/nitrogen/bg-saved.cfg" << EOF
[xin_-1]
file=$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg
mode=5
bgcolor=#000000
EOF

    # Also create nitrogen preferences
    cat > "$HOME/.config/nitrogen/nitrogen.cfg" << EOF
[geometry]
posx=0
posy=0
sizex=800
sizey=600

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs=$HOME/Pictures/Wallpapers;
EOF

    echo "  ✓ Nitrogen configured with TnEOS wallpaper"
    echo ""
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_wallpaper
fi

