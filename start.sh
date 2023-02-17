#!/bin/bash

echo "Sending config message..."

if [[ -z "$MQTT_HOST" ]]; then
    echo "No MQTT_HOST not found using localhost"
    MQTT_HOST=localhost
fi

if [[ -z "$MQTT_PORT" ]]; then
    echo "No MQTT_PORT found using 1883"
    MQTT_PORT=1883
fi

echo "Using MQTT defined in $MQTT_HOST:$MQTT_PORT"

json="{"
env | grep "CFG_MQTT_" |
{
    while read -r line; do
        name="${line%=*}"
        value="${line#*=}"
        name="${name#*CFG_MQTT_}"

        json="$json\"$name\":\"$value\","
    done

    json="${json%,*}"
    json="$json}"

    echo "will publish message"
    echo $json

    mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "config" -m $json
    echo "config published"
}

exit 0