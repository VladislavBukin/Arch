#!/bin/bash

# Проверка статуса интерфейса wg0 через sudo wg show
if sudo wg show wg0 | grep -q "interface: wg0"; then
    # Если интерфейс активен, выключаем его
    sudo wg-quick down wg0
else
    # Если интерфейс не активен, включаем его
	sudo resolvconf -u
	sudo wg-quick up wg0
fi
