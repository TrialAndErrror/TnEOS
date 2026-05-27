CONFIG="$HOME/.config/zed-projects.conf"
NOTIFY="notify-send -a Zed -i code"

choice=$(grep -v '^\s*#' "$CONFIG" \
  | rofi -dmenu -p "Open in Zed" -i)

[ -z "$choice" ] && exit 0

path="${choice#*: }"
uri="ssh://$path"

if ! zeditor "$uri" 2>/tmp/zed-launch-err; then
    err=$(cat /tmp/zed-launch-err)
    $NOTIFY "Failed to open project" "${choice%%:*}\n$err"
fi
