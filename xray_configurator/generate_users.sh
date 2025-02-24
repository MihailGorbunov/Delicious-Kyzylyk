#!/bin/bash

USERCOUNT=10
CLIENTSARRAY=''
for i in $(seq 1 $USERCOUNT);
do
    NEWCLIENT=`cat client.json`
    UUID=$(/xray uuid)
    NEWCLIENT=$(echo "$NEWCLIENT" | sed "s/#UUID/$UUID/g" | sed "s/#USERNAME/user_$i/g")    
    if [ ! $i = $USERCOUNT ]; then
    NEWCLIENT+=$',\n'
    fi
    CLIENTSARRAY+=$NEWCLIENT
done

echo "$CLIENTSARRAY" > clientsarray