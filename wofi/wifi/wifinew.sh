#!/bin/bash
# SCRIPT TO CONNECT TO NEW WIFI USING DMENU | ROFI

dir="$HOME/.config/wofi"
theme='style-1'

# bssid=$(nmcli device wifi list | sed -n '1!P'| cut -b 9- | dmenu -p "Wifi" -l 10 | awk '{print $1}')
# [ -z "$bssid" ] && exit 1
# pass=$(echo "" | dmenu -p "Enter password")
# [ -z "$pass" ] && notify-send "🔑 Password  not enterd" && exit 1
# nmcli device wifi connect $bssid password $pass

bssid=$(nmcli device wifi list | sed -n '1!P' | cut -b 9- | wofi --floating -dmenu -theme ${dir}/${theme}.rasi -p " " -lines 10 | awk '{print $1}')
[ -z "$bssid" ] && exit 1
pass=$(echo "" | wofi --floating -dmenu -theme-str 'textbox-prompt-colon {str: "";}' -theme ${dir}/${theme}.rasi -p "Enter password")
[ -z "$pass" ] && notify-send "🔑 Password not entered" && exit 1
nmcli device wifi connect $bssid password $pass
notify-send "📶 New WiFi Connected"
