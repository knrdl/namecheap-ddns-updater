#!/bin/sh 

INTERVAL="${INTERVAL:-30}"

echo "INTERVAL: $INTERVAL"

LAST_IP="127.0.0.1"

CURRENT_IP=""

while true; do
    if [[ -z "$STATIC_DNS_NAME" ]]; then
      CURRENT_IP="$(curl -s http://whatismyip.akamai.com/)"
    else
      CURRENT_IP="$(ping -c 1 "$STATIC_DNS_NAME" |  grep -o  '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*' | uniq)"
    fi

    if [[ "${CURRENT_IP}" != "${LAST_IP}" ]]; then 
        CURL_URL="https://dynamicdns.park-your-domain.com/update?host=${HOST}&domain=${DOMAIN}&password=${PASSWORD}&ip=${CURRENT_IP}"
        RES=$(curl -s "$CURL_URL")

        if [[ "$?" != "0" ]]; then 
            echo "curl '$CURL_URL' FAILED"
            sleep $INTERVAL
            continue 
        fi

        echo "$RES" | grep -o "<ErrCount>0</ErrCount>" > /dev/null
        
        if [[ "$?" != "0" ]]; then 
            echo "curl '$CURL_URL' FAILED"
            echo "Error: $RES"
            sleep $INTERVAL
            continue 
        fi

        echo "$RES" | grep -o "<IP>$CURRENT_IP</IP>" > /dev/null
        
        if [[ "$?" != "0" ]]; then 
            echo "curl '$CURL_URL' FAILED"
            echo "Error: $RES"
            echo "IP is not $CURRENT_IP" 
            sleep $INTERVAL
            continue 
        fi

        LAST_IP="$CURRENT_IP"
        echo "New IP is $CURRENT_IP"
    fi 
    sleep $INTERVAL
done
