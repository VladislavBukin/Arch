#!/bin/bash

DEVICE_TYPE=$1
ICON=$2

DEVICE_PATH=$(upower -e | grep $DEVICE_TYPE | head -n 1)

if [ -n "$DEVICE_PATH" ]; then
    PERCENTAGE=$(upower -i $DEVICE_PATH | grep 'percentage:' | awk '{print $2}')
    
    if [ -n "$PERCENTAGE" ]; then
        echo "{\"text\": \"$ICON $PERCENTAGE\", \"tooltip\": \"$DEVICE_TYPE: $PERCENTAGE\"}"
    else
        echo "{}"
    fi
else
    echo "{}"
fi
