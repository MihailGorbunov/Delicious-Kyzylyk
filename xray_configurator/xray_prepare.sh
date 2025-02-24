#!/bin/bash

if [ ! -f /connection/connection.txt ]; then

unzip xray.zip

# XRay config

rm /etc/xray/config.json
cp config.json /etc/xray/config.json

key_x25519=$(/xray x25519)
PKEY=$(echo "$key_x25519" | awk '/Private key:/ {print $3}')
PUBKEY=$(echo "$key_x25519" | awk '/Public key:/ {print $3}')

SID=$(openssl rand -hex 8)

sed -i -e "s/#PKEY/$PKEY/g" /etc/xray/config.json
sed -i -e "s/#SID/$SID/g" /etc/xray/config.json
sed -i -e "s/#SNI/$SNI/g" /etc/xray/config.json

# Connection string for ease of access

#cp -fr connstring.txt /connection/connstring.txt
IP=$(curl ipinfo.io/ip)

BASECONNSTRING=`cat connstring.txt`
BASECONNSTRING=$(echo "$BASECONNSTRING" |
sed "s/#IP/$IP/g" |
sed "s/#SNI/$SNI/g" |
sed "s/#PUBKEY/$PUBKEY/g" |
sed "s/#SID/$SID/g")

# Generate users

CLIENTSARRAY=''
CONNSTRINGARRAY=''
for i in $(seq 1 $USERCOUNT);
do
    # New entry in config.json
    NEWCLIENT=`cat client.json`
    UUID=$(/xray uuid)
    NEWCLIENT=$(echo "$NEWCLIENT" | sed "s/#UUID/$UUID/g" | sed "s/#USERNAME/user_$i/g")    
    if [ ! $i = $USERCOUNT ]; then
    NEWCLIENT+=$',@'
    fi
    CLIENTSARRAY+=$NEWCLIENT

    # New entry in connstring.txt
    NEWCONNSTRING="user_$i:"$'\n'
    NEWCONNSTRING+=$BASECONNSTRING
    NEWCONNSTRING=$(echo "$NEWCONNSTRING" | sed "s/#UUID/$UUID/g") 
    NEWCONNSTRING=$(echo "$NEWCONNSTRING" | sed "s/#NAME/"$NAME"_"$i"/g")
    
    CONNSTRINGARRAY+=$NEWCONNSTRING$'\n'
done

touch /connection/connstring.txt
echo "$CONNSTRINGARRAY" > /connection/connstring.txt

sed -i -e "s|#CLIENTS|$CLIENTSARRAY|g" /etc/xray/config.json
sed -i -e "s|@|\\n|g" /etc/xray/config.json

# Connection file to serve on nginx

touch /connection/connection.txt

echo '{' >> /connection/connection.txt
echo "\"PUBKEY\" : \"$PUBKEY\"," >> /connection/connection.txt
echo "\"UUID\" : \"$UUID\"," >> /connection/connection.txt
echo "\"SID\" : \"$SID\"," >> /connection/connection.txt
echo "\"SNI\" : \"$SNI\"" >> /connection/connection.txt
echo '}' >> /connection/connection.txt

fi

echo "Configuration is complete"