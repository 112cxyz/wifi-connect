#!/usr/bin/env bash

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Optional step - it takes couple of seconds (or longer) to establish a WiFi connection
# sometimes. In this case, following checks will fail and wifi-connect
# will be launched even if the device will be able to connect to a WiFi network.
# If this is your case, you can wait for a while and then check for the connection.
sleep 15

# Check for internet connectivity by pinging Google
google_ping() {
    wget --spider --quiet http://google.com
    return $?
}

# Check for an active WiFi connection
wifi_connected() {
    iwgetid -r &> /dev/null
    return $?
}

# Check for a default gateway
default_gateway() {
    ip route | grep -q default
    return $?
}

# Perform the checks
if wifi_connected && default_gateway && google_ping; then
    printf 'Internet is available, skipping WiFi Connect\n'
else
    printf 'No internet connection, starting WiFi Connect\n'
    ./wifi-connect
fi

# Start your application here.
sleep infinity
