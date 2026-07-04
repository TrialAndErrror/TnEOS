#!/usr/bin/env bash
# Copy TnEOS config files to ~/.config/, backing up any existing files
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

# Backup dir for the current copy session — set by copy_configs, used by helpers
_COPY_CONFIGS_BACKUP_DIR=""

_ensure_backup_dir() {
  [ -z "$_COPY_CONFIGS_BACKUP_DIR" ] && return
  [ -d "$_COPY_CONFIGS_BACKUP_DIR" ] && return
  mkdir -p "$_COPY_CONFIGS_BACKUP_DIR"
}

# Copy a directory config to ~/.config/, with diff checking.
# Args: src_dir dest_dir display_name
_install_dir_config() {
  local src="$1" dest="$2" name="$3"

  if [ ! -d "$src" ]; then
    echo "  ⚠ Source not found: $src, skipping..."
    return
  fi

  if [ -e "$dest" ]; then
    if diff -rqw "$src" "$dest" &>/dev/null; then
      echo "  ✓ $name is already up to date, skipping."
      return
    fi

    echo ""
    gum style --bold --foreground 212 "Changes detected in $name:"
    diff -rw -U 0 --color=always "$dest" "$src" || true
    echo ""

    if ! gum confirm "Overwrite ~/.config/$name with the repo version?"; then
      echo "  Skipping $name."
      return
    fi

    _ensure_backup_dir
    echo "  Backing up $name..."
    mv "$dest" "$_COPY_CONFIGS_BACKUP_DIR/$(basename "$dest")"
  fi

  echo "  Copying $name..."
  cp -r "$src" "$dest"
}

# Copy a single file to a system path (requires sudo), with diff checking.
# Args: src_file dest_file display_name
_install_system_file_config() {
  local src="$1" dest="$2" name="$3"

  if [ ! -f "$src" ]; then
    echo "  ⚠ Source not found: $src, skipping..."
    return
  fi

  if [ -e "$dest" ]; then
    if diff -qw "$src" "$dest" &>/dev/null; then
      echo "  ✓ $name is already up to date, skipping."
      return
    fi

    echo ""
    gum style --bold --foreground 212 "Changes detected in $name:"
    diff -w -U 0 --color=always "$dest" "$src" || true
    echo ""

    if ! gum confirm "Overwrite $dest with the repo version? (requires sudo)"; then
      echo "  Skipping $name."
      return
    fi

    local backup="${dest}.bak"
    if [ -e "$backup" ]; then
      backup="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
    fi
    echo "  Backing up $dest -> ${backup}"
    sudo mv "$dest" "$backup"
  fi

  local dest_dir
  dest_dir="$(dirname "$dest")"
  if [ ! -d "$dest_dir" ]; then
    echo "  Creating $dest_dir..."
    sudo mkdir -p "$dest_dir"
  fi

  echo "  Copying $name..."
  sudo cp "$src" "$dest"
}

# Copy a single file config (e.g. ~/.zshrc), with diff checking.
# Args: src_file dest_file display_name
_install_file_config() {
  local src="$1" dest="$2" name="$3"

  if [ ! -f "$src" ]; then
    echo "  ⚠ Source not found: $src, skipping..."
    return
  fi

  if [ -e "$dest" ]; then
    if diff -qw "$src" "$dest" &>/dev/null; then
      echo "  ✓ $name is already up to date, skipping."
      return
    fi

    echo ""
    gum style --bold --foreground 212 "Changes detected in $name:"
    diff -w -U 0 --color=always "$dest" "$src" || true
    echo ""

    if ! gum confirm "Overwrite ~/$name with the repo version?"; then
      echo "  Skipping $name."
      return
    fi

    _ensure_backup_dir
    echo "  Backing up $name..."
    mv "$dest" "$_COPY_CONFIGS_BACKUP_DIR/$(basename "$dest")"
  fi

  echo "  Copying $name..."
  cp "$src" "$dest"
}

copy_configs() {
  local REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
  local CONFIG_SRC="$REPO_DIR/config"
  local CONFIG_DEST="$HOME/.config"

  _COPY_CONFIGS_BACKUP_DIR="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"

  gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
    "Copying Configuration Files" "Installing dotfiles to ~/.config/"

  # Determine which configs to install
  local CONFIGS=("awesome" "picom" "rofi" "kitty")

  if [[ " ${PACMAN_PACKAGES[@]} " =~ " neovim " ]] || [[ "$INCLUDE_NVIM_CONFIG" == "true" ]]; then
    CONFIGS+=("nvim")
  fi

  # Detect or reuse already-exported device type
  if [ -z "${DEVICE_TYPE:-}" ]; then
    for supply_type in /sys/class/power_supply/*/type; do
      if [ -f "$supply_type" ] && grep -qi "^battery$" "$supply_type" 2>/dev/null; then
        DEVICE_TYPE="Laptop"
        break
      fi
    done

    if [ -z "$DEVICE_TYPE" ]; then
      gum style --bold --foreground 3 "Could not detect device type (no battery found)."
      DEVICE_TYPE=$(gum choose --header "Select your device type:" "Desktop" "Laptop")
    fi
  fi
  export DEVICE_TYPE

  # Prepare awesome config for desktop/laptop in a temp dir to avoid modifying the repo
  local AWESOME_SRC="$CONFIG_SRC/awesome"
  local AWESOME_TMP
  AWESOME_TMP="$(mktemp -d)"
  trap '[[ -n "${AWESOME_TMP:-}" ]] && rm -rf "$AWESOME_TMP"' RETURN
  cp -r "$AWESOME_SRC/." "$AWESOME_TMP/"

  if [ "$DEVICE_TYPE" = "Desktop" ]; then
    echo "Preparing awesome config for Desktop (no battery widget)..."
    rm -rf "$AWESOME_TMP/battery-widget"
    rm -f "$AWESOME_TMP/modules/config.laptop.lua"
    rm -f "$AWESOME_TMP/modules/keys.laptop.lua"
  else
    echo "Preparing awesome config for Laptop (with battery widget and brightness controls)..."
    cp "$AWESOME_TMP/modules/config.laptop.lua" "$AWESOME_TMP/modules/config.lua"
    cp "$AWESOME_TMP/modules/keys.laptop.lua" "$AWESOME_TMP/modules/keys.lua"
  fi
  echo ""

  # Preserve user's custom.lua across installs
  local CUSTOM_LUA="$CONFIG_DEST/awesome/custom.lua"
  local CUSTOM_LUA_BACKUP=""
  if [ -f "$CUSTOM_LUA" ]; then
    CUSTOM_LUA_BACKUP="$(mktemp)"
    cp "$CUSTOM_LUA" "$CUSTOM_LUA_BACKUP"
  fi

  echo "Installing configs to $CONFIG_DEST..."
  _install_dir_config "$AWESOME_TMP" "$CONFIG_DEST/awesome" "awesome"

  if [ -n "$CUSTOM_LUA_BACKUP" ]; then
    cp "$CUSTOM_LUA_BACKUP" "$CUSTOM_LUA"
    rm -f "$CUSTOM_LUA_BACKUP"
    echo "  ✓ Preserved existing ~/.config/awesome/custom.lua"
  fi
  # Preserve user's lua/local/ across nvim installs
  local NVIM_LOCAL=""
  if [[ " ${CONFIGS[@]} " =~ " nvim " ]]; then
    local NVIM_LOCAL_DIR="$CONFIG_DEST/nvim/lua/local"
    if [ -d "$NVIM_LOCAL_DIR" ]; then
      NVIM_LOCAL="$(mktemp -d)"
      cp -r "$NVIM_LOCAL_DIR/." "$NVIM_LOCAL/"
    fi
  fi

  for config in "${CONFIGS[@]}"; do
    [[ "$config" == "awesome" ]] && continue
    _install_dir_config "$CONFIG_SRC/$config" "$CONFIG_DEST/$config" "$config"
  done

  if [ -n "$NVIM_LOCAL" ]; then
    mkdir -p "$CONFIG_DEST/nvim/lua/local"
    cp -r "$NVIM_LOCAL/." "$CONFIG_DEST/nvim/lua/local/"
    rm -rf "$NVIM_LOCAL"
    echo "  ✓ Preserved existing ~/.config/nvim/lua/local/"
  fi

  # Install TnEOS zshrc as a separate file and source it from the user's .zshrc
  _install_file_config "$CONFIG_SRC/.zshrc" "$HOME/.zshrc_TnEOS" ".zshrc_TnEOS"
  local SOURCE_LINE='[ -f ~/.zshrc_TnEOS ] && source ~/.zshrc_TnEOS'
  if [ ! -f "$HOME/.zshrc" ]; then
    echo "$SOURCE_LINE" > "$HOME/.zshrc"
    echo "  ✓ Created ~/.zshrc with TnEOS source line"
  elif ! grep -qF "$SOURCE_LINE" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "$SOURCE_LINE" >> "$HOME/.zshrc"
    echo "  ✓ Added TnEOS source line to ~/.zshrc"
  else
    echo "  ✓ ~/.zshrc already sources .zshrc_TnEOS, skipping."
  fi
  _install_file_config "$CONFIG_SRC/.xprofile" "$HOME/.xprofile" ".xprofile"

  # Laptop-only: lid-switch behaviour
  if [ "$DEVICE_TYPE" = "Laptop" ]; then
    echo "Installing laptop system configs..."
    _install_system_file_config \
      "$CONFIG_SRC/logind.conf.d/lid.conf" \
      "/etc/systemd/logind.conf.d/lid.conf" \
      "logind.conf.d/lid.conf"
  fi

  # Install tutorial
  mkdir -p "$HOME/.config/TnEOS"
  _install_dir_config "$REPO_DIR/docs/tutorial" "$HOME/.config/TnEOS/tutorial" "TnEOS/tutorial"
  touch "$HOME/.config/TnEOS/.show-tutorial"
  echo "  ✓ Tutorial set to show on next login"

  if [ -d "$_COPY_CONFIGS_BACKUP_DIR" ]; then
    gum style --foreground 3 "  Previous configs backed up to: $_COPY_CONFIGS_BACKUP_DIR"
  fi

  echo ""
  gum style --bold --foreground 2 "✓ Configs installed to ~/.config/ and ~/"
  echo ""
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  copy_configs
fi
