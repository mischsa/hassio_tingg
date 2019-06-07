#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

THING_ID=$(jq --raw-output ".thing_id" $CONFIG_PATH)
THING_KEY=$(jq --raw-output ".thing_key" $CONFIG_PATH)
UPDATE_INTERVAL=$(jq --raw-output ".update_interval_seconds" $CONFIG_PATH)
THING_ENTITIES=$(jq --raw-output -c ".thing_entities[]" $CONFIG_PATH)

######################################################

echo "! Start tingg.io-bridge !"
echo "--------------------------------------------------------"
echo " "
echo "Read out the provided states and send"
echo "it to the corresponding resources on tingg.io!"
echo " "

while true
do
  for thing in $THING_ENTITIES; do
    tingg_resource=$(echo ${thing} | jq -r '.tingg_resource')
    hass_id=$(echo ${thing} | jq -r '.hass_id')
    #echo "Resource and Entity-ID:"
    #echo $tingg_resource
    #echo $hass_id
    # "jq '.state'" cuts the "state" value out of the entity-json object and -r outputs raw string (removes the surrounding quotes)
    STATE=$(curl -s -X GET -H "x-ha-access: ${HASSIO_TOKEN}" -H "Content-Type: application/json" http://hassio/homeassistant/api/states/$hass_id | jq -r '.state')
    #echo "Send state:"
    #echo $STATE
    mosquitto_pub -h "mqtt.tingg.io" -p "1883" -u "thing" -P "$THING_KEY" -i "$THING_ID" -t "$tingg_resource" -r -m $STATE
  done
  sleep $UPDATE_INTERVAL
done
