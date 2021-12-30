#!/bin/bash
if curl -s --head  --request GET $1 | grep "200 OK" > /dev/null; then 
        echo "webserver is UP"
    else
        echo "webserver is DOWN"
fi
 