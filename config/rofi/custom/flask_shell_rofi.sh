# Define colors
colors="red orange yellow green blue indigo violet"

# Use rofi to select color
selected_color=$(echo "$colors" | tr ' ' '\n' | rofi -dmenu -p "Select Environment Color")


flask_remote_shell() {
    local color=${1}

    if [[ -z "$color" ]]; then
        echo "Usage: flask_remote_shell <color>"
        return 1
    fi

    ssh -t azureuser@dev "docker exec -it production_${color}-web-1 flask shell" << EOF
        from shelltools import *
EOF
}


# Check if a color was selected
if [[ -n "$selected_color" ]]; then
    flask_remote_shell "$selected_color"
else
    echo "No color selected"
fi
