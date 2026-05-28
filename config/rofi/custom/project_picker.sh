set -euo pipefail


# Ensure user-local bin is on PATH when launched from rofi
export PATH="$HOME/.local/bin:$PATH"

# Build list from ~/repos directories, then append Notes and Cancel
mapfile -t repo_names < <(ls -1d "$HOME"/repos/*/ 2>/dev/null | xargs -I{} basename {})

menu_items=("${repo_names[@]}" "Notes" "— Cancel")

selection=$(printf '%s\n' "${menu_items[@]}" \
  | rofi -dmenu -no-custom -i -p "Open Project:")

# User canceled with Esc or chose the "Cancel" entry
[[ -z "${selection:-}" || "$selection" == "— Cancel" ]] && exit 0

if [[ "$selection" == "Notes" ]]; then
  path="$HOME/notes/"
else
  path="$HOME/repos/$selection/"
fi

[[ ! -d "$path" ]] && { notify-send "Open Project" "Invalid path for: $selection"; exit 1; }

# 4) Launch neovide inside the project's direnv environment (if available)
cd "$path"
# exec direnv exec . zeditor .
ghostty --working-directory="$path" -e sh -c "direnv exec . nvim ."
