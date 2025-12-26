#!/bin/bash

# List available Wi-Fi networks
networks=$(nmcli -f SSID,BARS dev wifi list | tail -n +2)

# Use Rofi to select a network
selected_network=$(echo "$networks" | rofi -dmenu -i -p "Select Wi-Fi Network" | awk '{print $1}')

# Exit if no network was selected
[ -z "$selected_network" ] && exit

# Prompt for the Wi-Fi password
password=$(rofi -dmenu -p "Enter Wi-Fi Password")

# Exit if no password was provided
[ -z "$password" ] && exit

# Connect to the selected network
nmcli dev wifi connect "$selected_network" password "$password"
