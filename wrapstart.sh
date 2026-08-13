#!/bin/bash

cd /data

set -e

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" server.properties
fi

if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" server.properties
fi

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if [[ -n "$WHITELIST" ]]; then
    sed -i "/white-list\s*=/ c white-list=true" server.properties
    echo $WHITELIST | awk -v RS=, '{print}' >> whitelist.txt
fi

if [[ -n "$RCONPASS" ]]; then
    sed -i "/enable-rcon\s*=/ c enable-rcon=true" server.properties
    sed -i "/rcon.password\s*=/ c rcon.password=$RCONPASS" server.properties
fi

ls . -al
bash ServerStart.sh
