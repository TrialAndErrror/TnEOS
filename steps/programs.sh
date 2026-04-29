#!/usr/bin/env bash
set -e

source ./ui.sh

WM_SELECTION=$(checklist "Window Managers" "Select window managers to install:" \
  awesome "Awesome WM" on \
  niri "Niri (Wayland compositor)" on \
) || return 1

WINDOW_MANAGERS=()
for wm in $WM_SELECTION; do
  WINDOW_MANAGERS+=("$wm")
done

# Base packages for all systems
PACMAN_PACKAGES=(rsync alacritty lightdm lightdm-gtk-greeter ttf-jetbrains-mono-nerd caja)
NIX_PACKAGES=(eza fd bat)

# Window manager packages
if [[ " ${WINDOW_MANAGERS[@]} " =~ " awesome " ]]; then
  PACMAN_PACKAGES+=(awesome picom rofi nitrogen)
fi
if [[ " ${WINDOW_MANAGERS[@]} " =~ " niri " ]]; then
  PACMAN_PACKAGES+=(niri)
fi

# Add laptop-specific packages (DEVICE_TYPE is set in admin.sh)
if [ "$DEVICE_TYPE" = "Laptop" ]; then
  PACMAN_PACKAGES+=(acpid)
  NIX_PACKAGES+=(brightnessctl)
fi

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
  zsh "zShell" on \
  7z "7z" on \
  docker   "Docker" on \
  docker-compose "Docker Compose" on \
  yazi "Yazi (TUI file manager)" on \
  tldr "TLDR (application info)" on \
  pavucontrol "PulseAudio Volume Control" on \
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
