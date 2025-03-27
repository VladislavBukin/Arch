#!/bin/bash
ODD_WP="/home/vlad/memes are DNA of the soul/wallpapers/gigaGrisha1.png"
EVEN_WP="/home/vlad/memes are DNA of the soul/wallpapers/cave_Grisha.jpg"

set_wallpaper() {
    local ws="$1"
    if (( ws % 2 == 0 )); then
        # Четное рабочее пространство – ставим обои для четных
        hyprctl hyprpaper wallpaper "eDP-1, $EVEN_WP"
    else
        # Нечетное рабочее пространство – ставим обои для нечетных
        hyprctl hyprpaper wallpaper "eDP-1, $ODD_WP"
    fi
}

# Подписка на события изменения workspace
hyprctl subscribe workspace | while read -r line; do
    # Извлекаем номер рабочего пространства
    ws=$(echo "$line" | grep -oE '[0-9]+')
    if [[ -n "$ws" ]]; then
        set_wallpaper "$ws"
    fi
done
