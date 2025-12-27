#!/usr/bin/env bash
set -e

source ./ui.sh

# Ask if desktop or laptop
DEVICE_TYPE=$(gum choose --header "Select your device type:" "Laptop" "Desktop")

# Base packages for all systems
PACMAN_PACKAGES=(awesome picom rofi rsync alacritty lightdm lightdm-gtk-greeter nitrogen ttf-jetbrains-mono-nerd)
NIX_PACKAGES=(eza fd bat)

# Add laptop-specific packages
if [ "$DEVICE_TYPE" = "Laptop" ]; then
  PACMAN_PACKAGES+=(acpid)
  NIX_PACKAGES+=(brightnessctl)
fi

# Export device type for use in main.sh
export DEVICE_TYPE

NIX_SELECTION=$(checklist "Nix Programs" "Select Nix programs to install:" \
  ripgrep "ripgrep (Grep alternative)" on \
  isort "isort (Python Import Sort)" on \
  pyright "Pyright (Python LSP)" on \
  uv "UV (Python package & project manager)" on \
  zellij "Zellij (Terminal multiplexer)" on \
  nushell "NuShell" on \
) || return 1

for item in $NIX_SELECTION; do
  NIX_PACKAGES+=("$item")
done

PACMAN_SELECTION=$(checklist "System Programs" "Select programs to install (via yay - supports AUR):" \
  neovim   "Neovim (editor)" on \
  7z "7z" on \
  docker   "Docker" on \
  docker-compose "Docker Compose" on \
  yazi "Yazi (TUI file manager)" on \
  tldr "TLDR (application info)" on \
  pavucontrol "PulseAudio Volume Control" on \
  nitrogen "Nitrogen (Wallpaper manager)" on \
  lxappearance "LXAppearance (Theme manager)" on \
  go "Go (programming language)" on \
  python314 "Python (programming language)" on \
  arandr "Arandr (Display manager)" on \
  flameshot "Flameshot (screenshot utility)" on
) || return 1

for item in $PACMAN_SELECTION; do
  PACMAN_PACKAGES+=("$item")
done

SOFTWARE_SELECTION=$(checklist "Optional Software" "Select optional applications to install:" \
  gitkraken "GitKraken (GUI Git management)" on \
  jetbrains.pycharm-professional "PyCharm Professional" on \
  libreoffice "LibreOffice" on \
  gimp "Gimp (Graphical image editor)" on \
  thorium-browser-bin "Thorium (web browser)" on \
  imagemagick "ImageMagick (CLI image editing)" on \
  neovide "Neovide (graphical NVIM client)" on \
  flatpak "Flatpak (package manager)" on \
  gh "gh (GitHub CLI)" on \
  httpie "httpie (HTTP TUI client)" on
) || return 1



for item in $SOFTWARE_SELECTION; do
  case $item in
    gitkraken|jetbrains.pycharm-professional|gh|httpie|neovide)
      NIX_PACKAGES+=("$item")
      ;;
    libreoffice|gimp|thorium-browser-bin|imagemagick|flatpak)
      PACMAN_PACKAGES+=("$item")
      ;;
  esac
done
