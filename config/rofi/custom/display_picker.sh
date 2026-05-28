#!/bin/bash

# Directory containing your scripts
SCRIPT_DIR=~/.screenlayout

# Use rofi to select a script
SELECTED_SCRIPT=$(ls "$SCRIPT_DIR" | rofi -dmenu -p "Select Screen Layout:")

# Run the selected script if not empty
if [ -n "$SELECTED_SCRIPT" ]; then
    bash "$SCRIPT_DIR/$SELECTED_SCRIPT"
fi

awesome-client 'awesome.restart()'
