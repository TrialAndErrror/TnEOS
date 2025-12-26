#!/usr/bin/env bash
# TnEOS Backup Restore Script
# Interactively restore configurations from backup

set -e

# Check if gum is installed
if ! command -v gum &> /dev/null; then
  echo "❌ Error: gum is required but not installed."
  echo "   Install it with: sudo pacman -S gum"
  exit 1
fi

BACKUP_BASE_DIR="$HOME/.config-backups"

# Check if backup directory exists
if [ ! -d "$BACKUP_BASE_DIR" ]; then
  gum style --bold --foreground 1 "❌ No backup directory found at $BACKUP_BASE_DIR"
  echo ""
  echo "No backups have been created yet."
  exit 1
fi

# Get list of backup directories
BACKUP_DIRS=($(ls -1 "$BACKUP_BASE_DIR" 2>/dev/null | sort -r))

if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
  gum style --bold --foreground 1 "❌ No backups found in $BACKUP_BASE_DIR"
  echo ""
  echo "The backup directory exists but contains no backups."
  exit 1
fi

# Display header
gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" \
  "TnEOS Backup Restore" \
  "Restore your configuration files from backup"

echo ""
gum style --bold --foreground 3 "Available backups (newest first):"
echo ""

# Let user select a backup
SELECTED_BACKUP=$(printf '%s\n' "${BACKUP_DIRS[@]}" | gum choose --header "Select a backup to restore:")

if [ -z "$SELECTED_BACKUP" ]; then
  echo "No backup selected. Exiting."
  exit 0
fi

BACKUP_PATH="$BACKUP_BASE_DIR/$SELECTED_BACKUP"

echo ""
gum style --bold --foreground 2 "Selected backup: $SELECTED_BACKUP"
echo ""

# Scan the backup directory to find what's available
AVAILABLE_ITEMS=()

# Check for .config items
if [ -d "$BACKUP_PATH" ]; then
  for item in awesome nvim picom rofi alacritty; do
    if [ -e "$BACKUP_PATH/$item" ]; then
      AVAILABLE_ITEMS+=("~/.config/$item")
    else
      # Check if the config exists now (was installed by TnEOS but didn't exist before)
      if [ -e "$HOME/.config/$item" ]; then
        AVAILABLE_ITEMS+=("~/.config/$item (didn't exist before - will be removed)")
      fi
    fi
  done
fi

if [ ${#AVAILABLE_ITEMS[@]} -eq 0 ]; then
  gum style --bold --foreground 1 "❌ No restorable items found in this backup"
  exit 1
fi

echo ""
gum style --bold --foreground 212 "Select items to restore:"
echo ""

# Let user select which items to restore (all selected by default)
SELECTED_ITEMS=$(printf '%s\n' "${AVAILABLE_ITEMS[@]}" | \
  gum choose --no-limit --selected="$(IFS=','; echo "${AVAILABLE_ITEMS[*]}")" \
  --header "Use space to toggle, enter to confirm")

if [ -z "$SELECTED_ITEMS" ]; then
  echo "No items selected. Exiting."
  exit 0
fi

# Convert selected items to array
mapfile -t ITEMS_TO_RESTORE <<< "$SELECTED_ITEMS"

echo ""
gum style --bold --foreground 3 "⚠ Warning: This will remove existing files and restore from backup"
echo ""
echo "Items to restore:"
for item in "${ITEMS_TO_RESTORE[@]}"; do
  echo "  • $item"
done
echo ""

if ! gum confirm "Continue with restore?"; then
  echo "Restore cancelled."
  exit 0
fi

echo ""
gum style --bold --foreground 2 "Starting restore..."
echo ""

# Perform the restore
for item in "${ITEMS_TO_RESTORE[@]}"; do
  # Check if this is a "didn't exist before" item
  if [[ "$item" == *"(didn't exist before - will be removed)" ]]; then
    # Extract the actual path (remove the suffix)
    CLEAN_ITEM="${item% (didn't exist before - will be removed)}"
    CONFIG_NAME=$(basename "$CLEAN_ITEM")
    echo "  Removing $CONFIG_NAME (didn't exist before TnEOS)..."
    rm -rf "$HOME/.config/$CONFIG_NAME"
    continue
  fi

  # Normal restore for items that existed before
  case "$item" in
    "~/.config/awesome")
      echo "  Restoring awesome..."
      rm -rf "$HOME/.config/awesome"
      cp -r "$BACKUP_PATH/awesome" "$HOME/.config/"
      ;;
    "~/.config/nvim")
      echo "  Restoring nvim..."
      rm -rf "$HOME/.config/nvim"
      cp -r "$BACKUP_PATH/nvim" "$HOME/.config/"
      ;;
    "~/.config/picom")
      echo "  Restoring picom..."
      rm -rf "$HOME/.config/picom"
      cp -r "$BACKUP_PATH/picom" "$HOME/.config/"
      ;;
    "~/.config/rofi")
      echo "  Restoring rofi..."
      rm -rf "$HOME/.config/rofi"
      cp -r "$BACKUP_PATH/rofi" "$HOME/.config/"
      ;;
    "~/.config/alacritty")
      echo "  Restoring alacritty..."
      rm -rf "$HOME/.config/alacritty"
      cp -r "$BACKUP_PATH/alacritty" "$HOME/.config/"
      ;;
  esac
done

echo ""
gum style --bold --foreground 2 --border rounded --padding "1 2" --margin "1" \
  "✓ Restore Complete!" \
  "" \
  "Your selected configurations have been restored from:" \
  "  $BACKUP_PATH"

echo ""

