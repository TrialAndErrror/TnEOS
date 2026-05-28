set -euo pipefail


# Ensure user-local bin is on PATH when launched from rofi
export PATH="$HOME/.local/bin:$PATH"

# 1) Your manual order for display
projects_order=(
  "Website"
  "Website Deployments"
  "Databuilder"
  "Notes"
  "Chatbot"
  "Descriptions Generator"
  "Report Server"
  "Sync Server"
  "ETL v2"
  "Migration Helper"
  "— Cancel"
)

# 2) Name → Path lookup
declare -A projects=(
  ["Website"]="$HOME/repos/website/"
  ["Website Deployments"]="$HOME/repos/website_deployments/"
  ["Databuilder"]="$HOME/repos/Data-Builder/"
  ["Chatbot"]="$HOME/repos/chatbot_server/"
  ["Notes"]="$HOME/notes/"
  ["Report Server"]="$HOME/repos/website_reports_server/"
  ["Sync Server"]="$HOME/repos/sync-server/"
  ["Descriptions Generator"]="$HOME/repos/dashboard_descriptions_generator/"
  ["Migration Helper"]="$HOME/repos/website-migration-helper/"
  ["ETL v2"]="$HOME/repos/etl-app-v2/"
)

# 3) Show menu in your manual order (no custom entries)
selection=$(printf '%s\n' "${projects_order[@]}" \
  | rofi -dmenu -no-custom -i -p "Open project")

# User canceled with Esc or chose the "Cancel" entry
[[ -z "${selection:-}" || "$selection" == "— Cancel" ]] && exit 0

path=${projects[$selection]:-}
[[ -z "$path" || ! -d "$path" ]] && { notify-send "Open Project" "Invalid path for: $selection"; exit 1; }

# 4) Launch neovide inside the project's direnv environment (if available)
cd "$path"
# exec direnv exec . zeditor .
ghostty --working-directory="$path" -e sh -c "direnv exec . nvim ."
