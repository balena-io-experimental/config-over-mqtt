#!/bin/sh

echo "Sending config message..."

if [[ -z "$MQTT_HOST" || -z "$MQTT_PORT" ]]; then
    echo "Please provide an MQTT Broker"
    exit 1
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

    mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "config" -m $json
    echo "config published"
}
