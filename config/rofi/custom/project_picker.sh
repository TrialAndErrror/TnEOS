set -euo pipefail


# Ensure user-local bin is on PATH when launched from rofi
export PATH="$HOME/.local/bin:$PATH"

# rofi doesn't run .zshrc, so pick up the ssh-agent that keychain started
# (otherwise ssh/sshfs from nvim prompts for key passphrases)
# shellcheck disable=SC1090
[[ -f "$HOME/.keychain/$(hostname)-sh" ]] && . "$HOME/.keychain/$(hostname)-sh"

# Same reason: API keys (e.g. OPENROUTER_API_KEY for codecompanion.nvim) live in
# an untracked env file that both this script and ~/.zshrc can source.
# Format: `export NAME=value` lines; keep it chmod 600.
# shellcheck disable=SC1090
[[ -f "$HOME/.config/secrets.env" ]] && . "$HOME/.config/secrets.env"

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
${TERMINAL:-kitty} -e sh -c "cd \"$path\" && direnv exec . nvim ."
