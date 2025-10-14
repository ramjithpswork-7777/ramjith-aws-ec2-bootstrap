#!/bin/bash
# bootstrap.sh - installs nginx and creates demo page

apt update -y
apt install -y nginx
systemctl enable nginx
systemctl start nginx

echo "<h1>Ramjith EC2 Bootstrap Demo</h1><p>Deployed via AWS CLI user-data.</p>" > /var/www/html/index.html
