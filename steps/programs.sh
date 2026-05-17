#!/usr/bin/env bash
set -e

source ./ui.sh

# Check if a system package is installed (distro-aware)
pacman_installed() {
  case "${DISTRO_TYPE:-Arch}" in
    Debian) dpkg -l "$1" 2>/dev/null | grep -q '^ii' ;;
    Fedora) rpm -q "$1" &>/dev/null 2>&1 ;;
    *)      pacman -Q "$1" &>/dev/null 2>&1 ;;
  esac
}

# Cache nix profile list to avoid repeated slow calls
_NIX_PROFILE_CACHE=""
_nix_profile() {
  if [ -z "$_NIX_PROFILE_CACHE" ]; then
    _NIX_PROFILE_CACHE=$(nix profile list 2>/dev/null || echo "")
  fi
  echo "$_NIX_PROFILE_CACHE"
}

# Check if a nix package is installed (by profile or binary in PATH)
nix_installed() {
  _nix_profile | grep -qF "$1" || command -v "$1" &>/dev/null 2>&1
}

# Return label with [installed] appended if the pacman package is already installed
pl() { pacman_installed "$1" && echo "$2 [installed]" || echo "$2"; }

# Return label with [installed] appended if the nix package is already installed
nl() { nix_installed "$1" && echo "$2 [installed]" || echo "$2"; }

# Base packages for all systems
PACMAN_PACKAGES=(awesome picom rofi rsync alacritty lightdm lightdm-gtk-greeter ttf-jetbrains-mono-nerd caja feh)
NIX_PACKAGES=(eza fd bat)

# Add laptop-specific packages (DEVICE_TYPE is set in admin.sh)
if [ "$DEVICE_TYPE" = "Laptop" ]; then
  PACMAN_PACKAGES+=(acpid)
  NIX_PACKAGES+=(brightnessctl)
fi

NIX_SELECTION=$(checklist "Nix Programs" "Select Nix programs to install:" \
  ripgrep "$(nl ripgrep 'ripgrep (Grep alternative)')" on \
  isort "$(nl isort 'isort (Python Import Sort)')" on \
  pyright "$(nl pyright 'Pyright (Python LSP)')" on \
  uv "$(nl uv 'UV (Python package & project manager)')" on \
  zellij "$(nl zellij 'Zellij (Terminal multiplexer)')" on \
  nushell "$(nl nushell 'NuShell')" on \
) || return 1

for item in $NIX_SELECTION; do
  nix_installed "$item" || NIX_PACKAGES+=("$item")
done

PACMAN_SELECTION=$(checklist "System Programs" "Select programs to install:" \
  neovim        "$(pl neovim 'Neovim (editor)')" on \
  zsh           "$(pl zsh 'zShell')" on \
  7zip          "$(pl 7zip '7zip')" on \
  docker        "$(pl docker 'Docker')" on \
  docker-compose "$(pl docker-compose 'Docker Compose')" on \
  yazi          "$(pl yazi 'Yazi (TUI file manager)')" on \
  tldr          "$(pl tldr 'TLDR (application info)')" on \
  pavucontrol   "$(pl pavucontrol 'PulseAudio Volume Control')" on \
  lxappearance  "$(pl lxappearance 'LXAppearance (Theme manager)')" on \
  go            "$(pl go 'Go (programming language)')" on \
  python        "$(pl python 'Python (programming language)')" on \
  arandr        "$(pl arandr 'Arandr (Display manager)')" on \
  flameshot     "$(pl flameshot 'Flameshot (screenshot utility)')" on \
) || return 1

for item in $PACMAN_SELECTION; do
  pacman_installed "$item" || PACMAN_PACKAGES+=("$item")
done

SOFTWARE_SELECTION=$(checklist "Optional Software" "Select optional applications to install:" \
  gitkraken                    "$(nl gitkraken 'GitKraken (GUI Git management)')" on \
  jetbrains.pycharm-professional "$(nl jetbrains.pycharm-professional 'PyCharm Professional')" on \
  libreoffice-fresh            "$(pl libreoffice-fresh 'LibreOffice')" on \
  gimp                         "$(pl gimp 'Gimp (Graphical image editor)')" on \
  chromium                     "$(pl chromium 'Chromium (web browser)')" on \
  imagemagick                  "$(pl imagemagick 'ImageMagick (CLI image editing)')" on \
  neovide                      "$(nl neovide 'Neovide (graphical NVIM client)')" on \
  flatpak                      "$(pl flatpak 'Flatpak (package manager)')" on \
  gh                           "$(nl gh 'gh (GitHub CLI)')" on \
  httpie                       "$(nl httpie 'httpie (HTTP TUI client)')" on \
) || return 1



for item in $SOFTWARE_SELECTION; do
  case $item in
    gitkraken|jetbrains.pycharm-professional|gh|httpie|neovide)
      nix_installed "$item" || NIX_PACKAGES+=("$item") ;;
    libreoffice-fresh|gimp|chromium|imagemagick|flatpak)
      pacman_installed "$item" || PACMAN_PACKAGES+=("$item") ;;
  esac
done
