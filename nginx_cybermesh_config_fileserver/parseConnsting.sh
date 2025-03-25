#!/bin/bash

# Clear previous 

if [ -f output.txt ]; then
rm output.txt
fi

rm ./share/*


if [ ! -f connstring.txt ]; then
echo "File connstring.txt not found"
fi

# Read base

touch output.txt
i=0;

while IFS= read -r line
do
    if [[ "$line" =~ user_[0-9]+: ]]; then
        user_name=$(echo "$line" | sed 's/://')
    elif [[ "$line" =~ vless:// ]]; then

        if echo "$line" | grep -qP 'vless://([a-f0-9\-]+)@([^:]+):443\?[^&]+&[^&]+&[^&]+&sni=([^&]+)&fp=chrome&pbk=([^&]+)&sid=([^&]+)&spx=[^&]+&type=tcp&headerType=none#([^ ]+)'; then

            i=$i+1;
            UUID=$(echo "$line" | sed -E 's/^vless:\/\/([a-f0-9\-]+)@.*/\1/')
            IP=$(echo "$line" | sed -E 's/^vless:\/\/[a-f0-9\-]+@([^:]+):443.*/\1/')
            SNI=$(echo "$line" | sed -E 's/.*sni=([^&]+).*/\1/')
            PUBKEY=$(echo "$line" | sed -E 's/.*pbk=([^&]+).*/\1/')
            SID=$(echo "$line" | sed -E 's/.*sid=([^&]+).*/\1/')
            NAME=$(echo "$line" | sed -E 's/.*#([^ ]+)$/\1/')

            NEWCONFIG=`cat configurator/cybermesh_config.json`
            NEWCONFIG=$(echo "$NEWCONFIG" |
            sed "s/#SERVERIP/$IP/g" |
            sed "s/#SNI/$SNI/g" |
            sed "s/#UUID/$UUID/g" |
            sed "s/#PUBKEY/$PUBKEY/g" |
            sed "s/#SID/$SID/g")

            echo "$NEWCONFIG" > ./share/config_$UUID
            
            echo "$user_name:" >> ./output.txt
            echo "cybermesh://nginx.remotemodelstudio.com/config_$UUID#Weisswurst_$i" >> ./output.txt

        else
            echo "Pattern did not match."
        fi
    fi
done < "connstring.txt"

cat output.txt