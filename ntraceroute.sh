#!/bin/bash

echo "=========================================================="
echo -e "\t\t\tNTraceroute"
echo -e "\t\t     Where's my packet?"
echo "=========================================================="

if [ "$1" = "" ]
then
        echo
        echo "You need to inform the target you will track."
        echo "Example: $0 google.com"
        exit 1
fi

ip_host=$(host -t A $1 | cut -d" " -f4)
echo
for i in $(seq 1 30)
do
        schema=$(echo "Router $i: ")
        resp=$(sudo hping3 -c 1 -t $i -1 $1 2>/dev/null | grep "ip=" | cut -d" " -f6 | cut -d"=" -f2)
        len=$(sudo hping3 -c 1 -t $i -1 $1 2>/dev/null | grep "len=")
        if [ -z "$resp" ] && [ -z "$len" ]
        then
                echo "$schema***"
                continue
        fi
        
        if [ -n "$len" ]
        then
                resp=$(sudo hping3 -c 1 -t $i -1 $1 2>/dev/null | grep "ip=" | cut -d" " -f2 | cut -d"=" -f2)
        fi
        
        echo "$schema$resp"

        if [ "$ip_host" = "$resp" ]
        then
                exit 0
        fi
done
