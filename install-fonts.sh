#!/usr/bin/env bash
# Standalone script to install Nerd Fonts
# Can be run independently without going through the full TnEOS installation

set -e

cd "$(dirname "$0")"

# Check if gum is installed
if ! command -v gum &> /dev/null; then
  echo "Error: gum is required but not installed."
  echo "Install it with: sudo pacman -S gum"
  exit 1
fi

# Note: Nerd Fonts are in official Arch repos, so pacman is sufficient
# No need to check for yay

# Source required files
source ./ui.sh
source ./install/install-nerd-fonts.sh

# Run the font installation
install_nerd_fonts

echo ""
gum style --bold --foreground 2 --border double --padding "1 2" --margin "1" \
  "Font Installation Complete!" \
  "" \
  "Your selected Nerd Fonts have been installed." \
  "Font cache has been refreshed." \
  "" \
  "You can run this script again anytime to:" \
  "  • Install additional fonts" \
  "  • Change your default font"

echo ""

