#!/bin/bash

dir="$HOME/.config/wofi"
theme='style-1'

# Порог для уровня сигнала (например, -60 dBm и выше)
signal_threshold=-120

# Файл для временного хранения списка сетей
wifi_temp_list="/tmp/wifi_list.txt"

# Функция для обновления списка Wi-Fi сетей
update_wifi_list() {
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

    # Записать обновленный список в временный файл
    echo "$wifi_list" > "$wifi_temp_list"
}

# Запустить обновление списка сетей в фоновом режиме
update_wifi_list &

# Показать текущий список сетей через wofi сразу, при этом он будет обновляться асинхронно
(
    tail -f "$wifi_temp_list" &
    wofi_pid=$!
    wofi --floating -dmenu -theme ${dir}/${theme}.rasi -p " " -lines 10 < "$wifi_temp_list" | awk '{print $1}' | {
        read selected_ssid
        kill $wofi_pid
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
    }
) &

# Периодическое обновление списка Wi-Fi сетей каждые 10 секунд
while true; do
    update_wifi_list
    sleep 10
done
