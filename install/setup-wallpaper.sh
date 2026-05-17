#!/usr/bin/env bash
# Install and configure TnEOS wallpaper
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

setup_wallpaper() {
  local REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

  # Copy TnEOS wallpaper (don't overwrite existing wallpapers)
  echo "Installing TnEOS wallpaper..."
  mkdir -p "$HOME/Pictures/Wallpapers"

  local WALLPAPER_SOURCE=""
  if [ -f "$REPO_DIR/config/backgrounds/wallpaper.jpg" ]; then
    WALLPAPER_SOURCE="$REPO_DIR/config/backgrounds/wallpaper.jpg"
  fi

  if [ -n "$WALLPAPER_SOURCE" ]; then
    cp -n "$WALLPAPER_SOURCE" "$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg"
    echo "  ✓ TnEOS wallpaper added to ~/Pictures/Wallpapers/"
  else
    echo "  ⚠ Warning: TnEOS wallpaper not found, skipping..."
  fi
  echo ""

  # Set wallpaper with feh (also writes ~/.fehbg for session restore)
  if [ -f "$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg" ] && command -v feh &>/dev/null; then
    echo "Setting wallpaper with feh..."
    feh --bg-fill "$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg"
    echo "  ✓ Wallpaper set"
    echo ""
  fi
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_wallpaper
fi

