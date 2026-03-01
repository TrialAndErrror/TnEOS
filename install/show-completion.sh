#!/usr/bin/env bash
# Show installation completion messages
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

show_completion() {
  # Build the config list dynamically
  local CONFIG_LIST="  ~/.config/awesome/
  ~/.config/picom/
  ~/.config/rofi/
  ~/.config/alacritty/"

  # Add nvim if it was selected
  if [[ " ${PACMAN_PACKAGES[@]} " =~ " neovim " ]]; then
    CONFIG_LIST="$CONFIG_LIST
  ~/.config/nvim/"
  fi

  gum style --bold --foreground 3 --border rounded --padding "1 2" --margin "1" \
    "Configuration Applied!" \
    "Your configs have been copied to:" \
    "$CONFIG_LIST" \
    "" \
    "TnEOS wallpaper added to:" \
    "  ~/Pictures/Wallpapers/tneos-wallpaper.jpg" \
    "" \
    "To update configs later:" \
    "  Edit files directly in ~/.config/"
  echo ""

  # Build final message
  local FINAL_MESSAGE="Installation Complete!
All packages have been installed successfully.

Next steps:"

  if [[ " ${PACMAN_PACKAGES[@]} " =~ " lightdm " ]]; then
    FINAL_MESSAGE="$FINAL_MESSAGE
  1. Reboot your system
  2. LightDM will start automatically
  3. Select 'Awesome' from the session menu
  4. Log in and enjoy!"
  else
    FINAL_MESSAGE="$FINAL_MESSAGE
  1. Log out of your current session
  2. Start Awesome WM with: echo 'exec awesome' > ~/.xinitrc && startx
  OR install a display manager (lightdm recommended)"
  fi

  gum style --bold --foreground 2 --border double --padding "1 2" --margin "1" \
    "$FINAL_MESSAGE"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  show_completion
fi

