#!/usr/bin/env bash
# TnEOS Web Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/TrialAndErrror/TnEOS/main/install.sh | bash

set -e

echo "======================================"
echo "  TnEOS Web Installer"
echo "======================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "❌ Please do not run this script as root."
  echo "   Run it as your regular user."
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

# Install git if not present
if ! command -v git &> /dev/null; then
  echo "Installing git..."
  sudo pacman -S --needed --noconfirm git
  echo "✓ git installed"
else
  echo "✓ git already installed"
fi

# Clone the repository
REPO_URL="https://github.com/TrialAndErrror/TnEOS.git"
INSTALL_DIR="$HOME/TnEOS"

if [ -d "$INSTALL_DIR" ]; then
  echo ""
  echo "⚠️  TnEOS directory already exists at $INSTALL_DIR"
  read -p "Remove and re-clone? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$INSTALL_DIR"
  else
    echo "Using existing directory..."
  fi
fi

if [ ! -d "$INSTALL_DIR" ]; then
  echo "Cloning TnEOS from $REPO_URL..."
  git clone "$REPO_URL" "$INSTALL_DIR"
  echo "✓ Repository cloned"
fi

# Change to the directory and run bootstrap
cd "$INSTALL_DIR"

echo ""
echo "======================================"
echo "  Starting TnEOS Bootstrap"
echo "======================================"
echo ""

# Run the bootstrap script
exec ./bootstrap.sh

