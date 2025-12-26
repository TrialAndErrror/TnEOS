#!/usr/bin/env bash
# TnEOS Bootstrap Script
# This script prepares the system and runs the main installation

set -e

echo "======================================"
echo "  TnEOS Bootstrap"
echo "======================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Please do not run this script as root."
  echo "   Run it as your regular user. It will ask for sudo when needed."
  exit 1
fi

# Check if we're on Arch Linux
if [ ! -f /etc/arch-release ]; then
  echo "⚠️  Warning: This script is designed for Arch Linux."
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

echo "Checking prerequisites..."
echo ""

# Check for internet connection
if ! ping -c 1 archlinux.org &> /dev/null; then
  echo "❌ No internet connection detected."
  echo "   Please connect to the internet and try again."
  exit 1
fi

echo "✓ Internet connection OK"

# Install gum if not present
if ! command -v gum &> /dev/null; then
  echo "Installing gum (required for TUI)..."
  sudo pacman -S --needed --noconfirm gum
  echo "✓ gum installed"
else
  echo "✓ gum already installed"
fi

# Check for Nix installation
if ! command -v nix &> /dev/null; then
  echo ""
  echo "⚠️  Nix is not installed."
  echo "   Nix is required for package management and Home Manager."
  echo ""
  read -p "Install Nix now? (Y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    
    # Source nix profile
    if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
    
    echo "✓ Nix installed"
    echo ""
    echo "⚠️  You may need to log out and log back in for Nix to work properly."
    echo "   Or run: source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    echo ""
    read -p "Continue with installation? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      echo "Please log out and log back in, then run ./main.sh"
      exit 0
    fi
  else
    echo "❌ Nix is required for this installation."
    echo "   Please install Nix manually and try again."
    exit 1
  fi
else
  echo "✓ Nix already installed"
fi

# Enable Nix experimental features (nix-command and flakes)
echo "Configuring Nix experimental features..."
sudo mkdir -p /etc/nix
if [ ! -f /etc/nix/nix.conf ] || ! grep -q "experimental-features" /etc/nix/nix.conf; then
  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf > /dev/null
  echo "✓ Nix experimental features enabled"

  # Restart nix-daemon to apply changes
  if systemctl is-active --quiet nix-daemon; then
    echo "Restarting nix-daemon..."
    sudo systemctl restart nix-daemon
  fi
else
  echo "✓ Nix experimental features already enabled"
fi
echo ""

# Ensure rsync is installed (needed for Home Manager setup)
if ! command -v rsync &> /dev/null; then
  echo "Installing rsync..."
  sudo pacman -S --needed --noconfirm rsync
  echo "✓ rsync installed"
else
  echo "✓ rsync already installed"
fi

echo ""
echo "======================================"
echo "  Prerequisites satisfied!"
echo "======================================"
echo ""
echo "Starting TnEOS installation..."
sleep 2

# Run the main installation script
exec ./main.sh

