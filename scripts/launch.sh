#!/bin/bash

sudo apt-get update && sudo apt-get install -y nginx stress

hostname=$(hostname)

sudo bash -c "echo '$hostname hello world' > /usr/share/nginx/html/index.html"

sudo sed  -i 's/80/8080/g' /etc/nginx/sites-enabled/default && sudo service nginx restart
