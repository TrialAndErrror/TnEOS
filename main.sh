#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

source ./state.sh
source ./ui.sh

# Step navigation
CURRENT_STEP=1

while true; do
  case $CURRENT_STEP in
    1)
      if source ./steps/admin.sh; then
        CURRENT_STEP=2
      else
        exit 1  # Can't go back from first step
      fi
      ;;
    2)
      if source ./steps/programs.sh; then
        CURRENT_STEP=3
      else
        CURRENT_STEP=1  # Go back
      fi
      ;;
    3)
      if source ./steps/homemanager.sh; then
        CURRENT_STEP=4
      else
        CURRENT_STEP=2  # Go back
      fi
      ;;
    4)
      if source ./steps/summary.sh; then
        CURRENT_STEP=5
        break
      else
        CURRENT_STEP=3  # Go back
      fi
      ;;
  esac
done

# Install Pacman packages
if [ ${#PACMAN_PACKAGES[@]} -gt 0 ]; then
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Pacman Packages" "${#PACMAN_PACKAGES[@]} packages selected"

  echo "Installing: ${PACMAN_PACKAGES[*]}"
  gum spin --spinner dot --title "Installing Pacman packages..." -- \
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

  gum style --bold --foreground 2 "✓ Pacman packages installed successfully"
  echo ""

  # Enable LightDM if it was installed
  if [[ " ${PACMAN_PACKAGES[@]} " =~ " lightdm " ]]; then
    echo "Enabling LightDM display manager..."
    sudo systemctl enable lightdm.service
    gum style --bold --foreground 2 "✓ LightDM enabled - will start on next boot"
    echo ""
  fi
fi

# Install Nix packages
if [ ${#NIX_PACKAGES[@]} -gt 0 ]; then
  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Installing Nix Packages" "${#NIX_PACKAGES[@]} packages selected"

  echo "Installing: ${NIX_PACKAGES[*]}"
  gum spin --spinner dot --title "Installing Nix packages..." -- \
    nix profile install "${NIX_PACKAGES[@]/#/nixpkgs#}"

  gum style --bold --foreground 2 "✓ Nix packages installed successfully"
  echo ""
fi

# Install and configure Home Manager
gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "Setting up Home Manager" "Installing and configuring dotfile management"

# Install Home Manager
if ! command -v home-manager &> /dev/null; then
  echo "Installing Home Manager..."
  gum spin --spinner dot --title "Installing Home Manager..." -- \
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

  gum spin --spinner dot --title "Updating Nix channels..." -- \
    nix-channel --update

  gum spin --spinner dot --title "Installing Home Manager package..." -- \
    nix-shell '<home-manager>' -A install
else
  echo "Home Manager already installed"
fi

# Backup existing config files
BACKUP_DIR="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"
CONFIGS_TO_BACKUP=("awesome" "nvim" "picom" "rofi" "alacritty")
BACKUP_NEEDED=false

echo "Checking for existing configuration files..."
for config in "${CONFIGS_TO_BACKUP[@]}"; do
  if [ -e "$HOME/.config/$config" ]; then
    BACKUP_NEEDED=true
    break
  fi
done

if [ "$BACKUP_NEEDED" = true ]; then
  gum style --bold --foreground 3 "⚠ Existing config files detected"
  if gum confirm "Backup existing config files to $BACKUP_DIR?"; then
    mkdir -p "$BACKUP_DIR"
    echo "Backing up existing configurations..."

    for config in "${CONFIGS_TO_BACKUP[@]}"; do
      if [ -e "$HOME/.config/$config" ]; then
        echo "  Backing up ~/.config/$config"
        mv "$HOME/.config/$config" "$BACKUP_DIR/"
      fi
    done

    gum style --bold --foreground 2 "✓ Backup created at: $BACKUP_DIR"
    echo ""
  else
    gum style --bold --foreground 1 "⚠ Warning: Existing files will be overwritten!"
    gum confirm "Continue anyway?" || exit 1
  fi
fi

# Copy home-manager configuration to user's home directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HM_CONFIG_DIR="$HOME/.config/home-manager"

echo "Setting up Home Manager configuration..."
mkdir -p "$HM_CONFIG_DIR"

# Copy the entire home-manager directory
gum spin --spinner dot --title "Copying Home Manager configuration..." -- \
  rsync -av "$SCRIPT_DIR/home-manager/" "$HM_CONFIG_DIR/"

# Conditionally remove nvim config if neovim wasn't selected
if [[ ! " ${PACMAN_PACKAGES[@]} " =~ " neovim " ]]; then
  echo "Neovim not selected, removing nvim configuration from Home Manager..."
  # Remove the nvim config block from home.nix using markers
  sed -i '/# CONDITIONAL_NVIM_START/,/# CONDITIONAL_NVIM_END/d' "$HM_CONFIG_DIR/home.nix"
  # Also update the EDITOR variable
  sed -i 's/EDITOR = "nvim";/EDITOR = "vim";/' "$HM_CONFIG_DIR/home.nix"
fi

# Apply Home Manager configuration
echo "Applying Home Manager configuration..."
gum spin --spinner dot --title "Applying Home Manager configuration..." -- \
  home-manager switch

gum style --bold --foreground 2 "✓ Home Manager configured successfully"
echo ""

# Copy TnEOS wallpaper (don't overwrite existing wallpapers)
echo "Installing TnEOS wallpaper..."
mkdir -p "$HOME/Pictures/Wallpapers"
if [ -f "$HM_CONFIG_DIR/assets/backgrounds/wallpaper.jpg" ]; then
  cp -n "$HM_CONFIG_DIR/assets/backgrounds/wallpaper.jpg" "$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg"
  echo "  ✓ TnEOS wallpaper added to ~/Pictures/Wallpapers/"
fi
echo ""

if [ "$BACKUP_NEEDED" = true ] && [ -d "$BACKUP_DIR" ]; then
  gum style --bold --foreground 3 --border rounded --padding "1 2" --margin "1" \
    "Backup Information" \
    "Your old config files are backed up at:" \
    "  $BACKUP_DIR" \
    "" \
    "You can restore them anytime if needed."
  echo ""
fi

# Build the config list dynamically
CONFIG_LIST="  ~/.config/awesome/
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
  "Your configs have been symlinked to:" \
  "$CONFIG_LIST" \
  "" \
  "TnEOS wallpaper added to:" \
  "  ~/Pictures/Wallpapers/tneos-wallpaper.jpg" \
  "" \
  "To update configs later:" \
  "  1. Edit files in ~/.config/home-manager/" \
  "  2. Run: home-manager switch"
echo ""

# Build final message
FINAL_MESSAGE="Installation Complete!
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
