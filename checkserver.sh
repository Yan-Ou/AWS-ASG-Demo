#!/bin/bash
while true; do
terraform output elb_url | sed -e 's/^"//' -e 's/"$//' | xargs ./check.sh
sleep 1
done