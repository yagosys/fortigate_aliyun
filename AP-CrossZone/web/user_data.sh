#!/bin/bash -v
echo "userdata-start"
sudo apt update -y
sudo apt install -y nginx
sudo sed -i 's/80/8080/' /etc/nginx/sites-available/default
sudo service nginx stop
sudo service nginx start
echo "userdata-end"

