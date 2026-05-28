set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

# Parse top-level Host entries from SSH config (skip wildcards)
mapfile -t hosts < <(grep -i "^Host " "$HOME/.ssh/config" | awk '{print $2}' | grep -v '\*')

selection=$(printf '%s\n' "${hosts[@]}" \
  | rofi -dmenu -no-custom -i -p "SSH:")

[[ -z "${selection:-}" ]] && exit 0

ghostty -e ssh "$selection"
