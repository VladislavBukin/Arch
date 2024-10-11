#!/bin/bash

if sudo wg show wg0 | grep -q "interface: wg0"; then
    output="{\"text\": \"wg-up\", \"class\": \"up\", \"tooltip\": \"WireGuard is UP\"}"
	#output="wgup"
else
    output="{\"text\": \"wg-down\", \"class\": \"down\", \"tooltip\": \"WireGuard is DOWN\"}"
	#output="wgdown"
fi

echo "$output"
