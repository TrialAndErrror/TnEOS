set -euo pipefail


# Ensure user-local bin is on PATH when launched from rofi
export PATH="$HOME/.local/bin:$PATH"

# 1) Your manual order for display
configs_order=(
  "Awesome (rc.lua)"
  "ZShell (.zshrc)"
  "NVIM (init.lua)"
  "SSH (.ssh/config)"
  "GhosTTY (config)"
  "Zellij (config.kdl)"
  "Rofi (config.rasi)"
  "— Cancel"
)

# 2) Name → Path lookup
declare -A configs=(
  ["Awesome (rc.lua)"]="$HOME/.config/awesome/rc.lua"
  ["ZShell (.zshrc)"]="$HOME/.zshrc"
  ["NVIM (init.lua)"]="$HOME/.config/nvim/init.lua"
  ["GhosTTY (config)"]="$HOME/.config/ghostty/config"
  ["SSH (.ssh/config)"]="$HOME/.ssh/config"
  ["Rofi (config.rasi)"]="$HOME/.config/rofi/config.rasi"
  ["Zellij (config.kdl)"]="$HOME/.config/zellij/config.kdl"
)

# 3) Show menu in your manual order (no custom entries)
selection=$(printf '%s\n' "${configs_order[@]}" \
  | rofi -dmenu -no-custom -i -p "Edit Config")

# User canceled with Esc or chose the "Cancel" entry
[[ -z "${selection:-}" || "$selection" == "— Cancel" ]] && exit 0

path=${configs[$selection]:-}
[[ -z "$path" ]] && { notify-send "Edit Config" "Invalid path for: $selection"; exit 1; }

# 4) Launch nvim in terminal and open the selected file
ghostty --working-directory="$path" -e sh -c "direnv exec . nvim $path"
