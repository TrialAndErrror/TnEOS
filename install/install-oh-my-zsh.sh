#!/usr/bin/env bash
# Install oh-my-zsh and optionally set zsh as the default shell
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

install_oh_my_zsh() {
  # Only run if zsh was selected or is already installed
  if ! command -v zsh &>/dev/null; then
    echo "  ⚠ zsh not found, skipping oh-my-zsh install."
    return 0
  fi

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Oh My Zsh" "Setting up zsh configuration"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    gum style --bold --foreground 2 "✓ oh-my-zsh already installed, skipping."
    echo ""
  else
    echo "Installing oh-my-zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    gum style --bold --foreground 2 "✓ oh-my-zsh installed"
    echo ""
  fi

  # Offer to set zsh as default shell
  local current_shell
  current_shell="$(getent passwd "$USER" | cut -d: -f7)"
  local zsh_path
  zsh_path="$(command -v zsh)"

  if [ "$current_shell" = "$zsh_path" ]; then
    gum style --bold --foreground 2 "✓ zsh is already your default shell"
  elif gum confirm "Set zsh as your default shell?"; then
    chsh -s "$zsh_path"
    gum style --bold --foreground 2 "✓ Default shell set to zsh (takes effect on next login)"
  fi

  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_oh_my_zsh
fi
