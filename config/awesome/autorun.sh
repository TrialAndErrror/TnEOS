#!/usr/bin/env sh

function run {
    if ! pgrep $1 ; then
        $@&
    fi
}

nitrogen --restore
xev -version

# Generic command for all touchpads
xinput set-prop "$(xinput list --name-only | grep -i touch)" "libinput Tapping Enabled" 1
picom -b --config ~/.config/picom/configs/custom.conf
