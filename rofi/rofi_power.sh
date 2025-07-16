#!/bin/bash

chosen=$(printf " Shutdown\n Reboot\n Logout" | rofi -dmenu -i -p "Power" -theme-str 'window {width: 200;}')

[ -z "$chosen" ] && exit 1  # Exit if nothing was selected

confirm=$(printf "No\nYes" | rofi -dmenu -i -p "Are you sure?" -theme-str 'window {width: 200;}')

if [[ "$confirm" != "Yes" ]]; then
    exit 1
fi

case "$chosen" in
    *Shutdown) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Logout) pkill -KILL -u "$USER" ;;
    *) exit 1 ;;
esac
