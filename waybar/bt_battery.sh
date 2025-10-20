#!/bin/bash

# Ищем устройство, которое является гарнитурой или наушниками
# upower -e | grep -E 'headset|headphone'
DEVICE_PATH=$(upower -e | grep -E 'headset|headphone' | head -n 1)

# Если путь к устройству не найден, выходим
if [ -z "$DEVICE_PATH" ]; then
    exit 0
fi

# Получаем процент заряда для найденного устройства
BATTERY_LEVEL=$(upower -i $DEVICE_PATH | grep "percentage:" | awk '{print $2}' | tr -d '%')

# Если уровень заряда получен, выводим JSON
if [ -n "$BATTERY_LEVEL" ]; then
    echo "{\"text\": \" ${BATTERY_LEVEL}%\", \"tooltip\": \"Наушники: ${BATTERY_LEVEL}%\", \"class\": \"plugged\"}"
else
    # Если по какой-то причине уровень заряда не найден, выходим
    exit 0
fi
