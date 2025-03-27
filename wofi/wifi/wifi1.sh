#!/bin/bash

dir="$HOME/.config/wofi"
theme='style-1'

# Порог для уровня сигнала (например, -60 dBm и выше)
signal_threshold=-120

# Получение списка Wi-Fi сетей с сортировкой по уровню сигнала и фильтрацией
bssid=$(nmcli device wifi list | awk -v threshold="$signal_threshold" '$8 > threshold {print $0}' | sed -n '1!P' | cut -b 9- | wofi --floating -dmenu -theme ${dir}/${theme}.rasi -p " " -lines 10 | awk '{print $1}')

# Если не выбрано ни одной сети, выход
[ -z "$bssid" ] && exit 1

# Подключение к выбранной сети
nmcli device wifi connect $bssid
