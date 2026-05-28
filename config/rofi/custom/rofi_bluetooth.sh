#!/bin/bash

CONNECTED_PREFIX="[on] "

paired=$(bluetoothctl devices Paired 2>/dev/null)

if [ -z "$paired" ]; then
    notify-send "Bluetooth" "No paired devices found"
    exit 1
fi

declare -A mac_map
menu_items=""

while IFS= read -r line; do
    mac=$(awk '{print $2}' <<< "$line")
    name=$(cut -d' ' -f3- <<< "$line")

    if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
        label="${CONNECTED_PREFIX}${name}"
    else
        label="$name"
    fi

    mac_map["$label"]="$mac"
    menu_items+="$label\n"
done <<< "$paired"

selected=$(printf "%b" "$menu_items" | rofi -dmenu -i -p "Bluetooth")

[ -z "$selected" ] && exit 0

mac="${mac_map[$selected]}"

if [[ "$selected" == "${CONNECTED_PREFIX}"* ]]; then
    bluetoothctl disconnect "$mac"
    notify-send "Bluetooth" "Disconnected from ${selected#"${CONNECTED_PREFIX}"}"
else
    notify-send "Bluetooth" "Connecting to $selected..."
    bluetoothctl connect "$mac"
fi
