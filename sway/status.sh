#!/bin/sh

# Used by sway to generate the status bar text.
#
# Requires
# - date
# - pamixer
# - network-manager (nmcli)
# - upower
#
# Author: Ben Potter
# Date: Sep 1 2024

WIFI_IFACE="wlp1s0f0"
BATTERY_OBJECT_PATH="/org/freedesktop/UPower/devices/battery_macsmc_battery"

while true 
do 
	date=$(date +"%D")
	time=$(date +"%T")

	volume=$(pamixer --get-volume)

	wifissid=$(nmcli -g general.connection device show $WIFI_IFACE)
	wifistate=$(nmcli -g general.state device show $WIFI_IFACE)
	
	batterycharge=$(upower -i $BATTERY_OBJECT_PATH | grep percentage \
		| awk '{print $2}')
	batterystate=$(upower -i $BATTERY_OBJECT_PATH | grep state \
		| awk '{print $2}')

	echo "$wifissid $wifistate | $batterystate $batterycharge |"\
		"vol: $volume% | $date | $time"
	sleep 1
done

