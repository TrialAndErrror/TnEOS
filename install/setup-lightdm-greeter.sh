#!/usr/bin/env bash
set -e

# Source UI functions if available
if [ -f "./ui.sh" ]; then
  source ./ui.sh
fi

setup_lightdm_greeter() {
  echo "Setting up LightDM GTK Greeter customization..."
  echo ""

  # Check if lightdm is installed
  if ! command -v lightdm &> /dev/null; then
    echo "LightDM is not installed. Skipping greeter customization."
    return 0
  fi

  # Install required themes
  echo "Installing required themes and icons..."
  if command -v yay &> /dev/null; then
    yay -S --needed --noconfirm matcha-gtk-theme papirus-icon-theme breeze breeze-gtk
    echo "  ✓ Themes installed (Matcha, Papirus, Breeze)"
  else
    echo "  ⚠ yay not found, skipping theme installation"
    echo "  Please install manually: yay -S matcha-gtk-theme papirus-icon-theme breeze breeze-gtk"
  fi
  echo ""

  # Backup existing configuration
  if [ -f /etc/lightdm/lightdm-gtk-greeter.conf ]; then
    echo "Backing up existing greeter configuration..."
    sudo cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.backup
    echo "  ✓ Backup created at /etc/lightdm/lightdm-gtk-greeter.conf.backup"
  fi

  # Ensure wallpaper exists
  WALLPAPER_PATH="$HOME/Pictures/Wallpapers/tneos-wallpaper.jpg"
  if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Warning: TnEOS wallpaper not found at $WALLPAPER_PATH"
    echo "Using default background instead."
    WALLPAPER_PATH="/usr/share/backgrounds/mabox-lumo.jpg"
  fi

  # Create custom greeter configuration
  echo "Creating custom LightDM GTK Greeter configuration..."
  
  sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null << EOF
[greeter]
# Background wallpaper
background = $WALLPAPER_PATH

# Font settings
font-name = JetBrainsMono Nerd Font 11
xft-antialias = true
xft-hintstyle = hintfull
xft-rgba = rgb

# Theme settings
theme-name = Matcha-dark-pueril
icon-theme-name = Papirus-Dark
cursor-theme-name = Breeze

# Clock settings
show-clock = true
clock-format = %A, %B %d  %H:%M

# User settings
default-user-image = #avatar-default-symbolic
hide-user-image = false
round-user-image = true

# Panel settings
panel-position = bottom
indicators = ~host;~spacer;~clock;~spacer;~session;~language;~a11y;~power

# Screen settings
screensaver-timeout = 60

# Position settings (centered login box)
position = 50%,center 50%,center

# Additional settings
active-monitor = #cursor
keyboard = onboard
reader = orca
a11y-states = +keyboard;+reader
EOF

  echo "  ✓ LightDM GTK Greeter configuration created"
  echo ""

  # Optional: Install lightdm-gtk-greeter-settings for GUI customization
  if command -v yay &> /dev/null; then
    read -p "Would you like to install lightdm-gtk-greeter-settings (GUI tool for customization)? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Installing lightdm-gtk-greeter-settings..."
      yay -S --needed --noconfirm lightdm-gtk-greeter-settings
      echo "  ✓ You can now run 'lightdm-gtk-greeter-settings' to customize the greeter with a GUI"
    fi
  fi

  echo ""
  echo "LightDM Greeter Customization Complete!"
  echo ""
  echo "Configuration details:"
  echo "  • Background: $WALLPAPER_PATH"
  echo "  • Theme: Matcha-dark-pueril"
  echo "  • Icons: Papirus-Dark"
  echo "  • Font: JetBrainsMono Nerd Font"
  echo "  • Clock: Enabled with date/time"
  echo ""
  echo "To see changes, restart LightDM or reboot your system:"
  echo "  sudo systemctl restart lightdm"
  echo ""
  echo "To further customize, edit:"
  echo "  /etc/lightdm/lightdm-gtk-greeter.conf"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_lightdm_greeter
fi

