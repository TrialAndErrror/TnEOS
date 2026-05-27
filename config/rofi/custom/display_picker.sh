#!/bin/bash

# Directory containing your scripts
SCRIPT_DIR=~/.screenlayout

# Use rofi to select a script
SELECTED_SCRIPT=$(ls "$SCRIPT_DIR" | rofi -dmenu -theme ~/.config/rofi/powermenu/type-1/style-1.rasi -p "Run script")

# Run the selected script if not empty
if [ -n "$SELECTED_SCRIPT" ]; then
    bash "$SCRIPT_DIR/$SELECTED_SCRIPT"
fi

awesome-client 'awesome.restart()'
