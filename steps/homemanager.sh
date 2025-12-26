#!/usr/bin/env bash
set -e

source ./ui.sh

gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "Home Manager Setup" "Configure dotfiles and assets management"

gum style --bold --foreground 2 "✓ Home Manager will be installed and configured"

msgbox "Home Manager Configuration" \
"Home Manager will manage your dotfiles.

Configuration location: ./home-manager/

Your configs will be symlinked to:
  • ~/.config/awesome/
  • ~/.config/nvim/
  • ~/.config/picom/
  • ~/.config/rofi/
  • ~/.config/alacritty/

TnEOS wallpaper will be copied to:
  • ~/Pictures/Wallpapers/tneos-wallpaper.jpg
  (Your existing wallpapers won't be touched)"

echo ""

