#!/usr/bin/env sh

function run {
    if ! pgrep $1 ; then
        $@&
    fi
}

~/.fehbg &
xev -version

# Generic command for all touchpads
touchpad="$(xinput list --name-only | grep -i touch | head -n1)"
[ -n "$touchpad" ] && xinput set-prop "$touchpad" "libinput Tapping Enabled" 1
picom -b --config ~/.config/picom/picom.conf
run nm-applet
run volumeicon
run blueman-applet

[ -f "$HOME/.config/TnEOS/.show-tutorial" ] && python3 "$HOME/.config/TnEOS/tutorial/tutorial.py" &
