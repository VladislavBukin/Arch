#!/bin/bash

dir="$HOME/.config/wofi"
theme='style-1'

# Порог для уровня сигнала (например, -60 dBm и выше)
signal_threshold=-120

# Получение имени текущей подключенной сети
current_ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

# Получение списка Wi-Fi сетей с сортировкой по уровню сигнала и фильтрацией
wifi_list=$(nmcli -f SSID,RATE,SIGNAL,SECURITY device wifi list | awk -v threshold="$signal_threshold" 'NR>1 && $3 > threshold {print $0}' | sort -k1,1 -k2,2nr | awk '!seen[$1]++')

# Проверка и перемещение текущей сети на верх списка
if [[ ! -z "$current_ssid" ]]; then
    # Найти текущую сеть в списке и пометить её звездочкой
    current_network=$(echo "$wifi_list" | grep "^$current_ssid")
    wifi_list=$(echo "$wifi_list" | grep -v "^$current_ssid")
    wifi_list="* $current_network"$'\n'"$wifi_list"
fi

# Показать сети через wofi
selected_ssid=$(echo "$wifi_list" | wofi --floating -dmenu -theme ${dir}/${theme}.rasi -p " " -lines 10 | awk '{print $1}')

# Если не выбрано ни одной сети, выход
[ -z "$selected_ssid" ] && exit 1

# Запрос пароля, если требуется
password_prompt() {
    password=$(wofi --dmenu -p "Введите пароль для $selected_ssid:")
    echo "$password"
}

# Подключение к выбранной сети
nmcli device wifi connect "$selected_ssid" password "$(password_prompt)" || {
    notify-send "Ошибка подключения" "Неверный пароль или не удалось подключиться к $selected_ssid"
}
