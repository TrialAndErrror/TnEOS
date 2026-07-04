#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../ui.sh"

BACKUP_BASE_DIR="$HOME/.config-backups"

manage_backups() {
  if [ ! -d "$BACKUP_BASE_DIR" ] || [ -z "$(ls -A "$BACKUP_BASE_DIR" 2>/dev/null)" ]; then
    gum style --bold --foreground 1 "No backups found at $BACKUP_BASE_DIR"
    echo ""
    return 0
  fi

  local backup_dirs=()
  mapfile -t backup_dirs < <(ls -1r "$BACKUP_BASE_DIR" 2>/dev/null)

  while true; do
    local display_items=()
    for dir in "${backup_dirs[@]}"; do
      local items
      items=$(ls -1 "$BACKUP_BASE_DIR/$dir" 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
      display_items+=("$dir  ($items)")
    done
    display_items+=("— Done")

    gum style --bold --foreground 212 --border double --padding "1 2" --margin "1" "Backup Manager"
    echo ""

    local selected
    selected=$(gum choose --header "Select a backup:" "${display_items[@]}") || return 0
    [[ "$selected" == "— Done" ]] && return 0

    local backup_name="${selected%%  (*}"
    local backup_path="$BACKUP_BASE_DIR/$backup_name"

    echo ""
    local action
    action=$(gum choose --header "Backup: $backup_name" "Restore" "Delete" "Cancel") || continue

    case "$action" in
      "Restore")
        _do_restore "$backup_path"
        echo ""
        ;;
      "Delete")
        if gum confirm "Permanently delete backup $backup_name?"; then
          rm -rf "$backup_path"
          gum style --bold --foreground 2 "✓ Deleted $backup_name"
          mapfile -t backup_dirs < <(ls -1r "$BACKUP_BASE_DIR" 2>/dev/null)
          if [ ${#backup_dirs[@]} -eq 0 ]; then
            echo ""
            gum style --foreground 3 "No more backups."
            return 0
          fi
        fi
        ;;
      "Cancel") continue ;;
    esac
  done
}

_do_restore() {
  local backup_path="$1"
  local backup_name
  backup_name="$(basename "$backup_path")"

  local items=()
  mapfile -t items < <(ls -1 "$backup_path" 2>/dev/null)

  if [ ${#items[@]} -eq 0 ]; then
    gum style --bold --foreground 1 "Backup is empty."
    return 1
  fi

  local display_items=()
  for item in "${items[@]}"; do
    case "$item" in
      .zshrc|.xprofile) display_items+=("~/$item") ;;
      *)                display_items+=("~/.config/$item") ;;
    esac
  done

  echo ""
  local selected_display
  selected_display=$(printf '%s\n' "${display_items[@]}" | \
    gum choose --no-limit \
    --selected="$(IFS=','; echo "${display_items[*]}")" \
    --header "Select items to restore from $backup_name:") || return 0

  [ -z "$selected_display" ] && { echo "Nothing selected."; return 0; }

  echo ""
  gum style --bold --foreground 3 "⚠ This will overwrite your current configs."
  echo ""
  gum confirm "Restore selected items?" || return 0

  echo ""
  while IFS= read -r display_path; do
    local item dest
    if [[ "$display_path" == "~/.config/"* ]]; then
      item="${display_path:10}"
      dest="$HOME/.config/$item"
    else
      item="${display_path:2}"
      dest="$HOME/$item"
    fi

    local src="$backup_path/$item"
    if [ ! -e "$src" ]; then
      echo "  ⚠ Not found in backup: $item"
      continue
    fi

    echo "  Restoring $display_path..."
    rm -rf "$dest"
    cp -r "$src" "$dest"
    gum style --foreground 2 "  ✓ $display_path"
  done <<< "$selected_display"

  echo ""
  gum style --bold --foreground 2 "✓ Restore complete"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  manage_backups
fi
