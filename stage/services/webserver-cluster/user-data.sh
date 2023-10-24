#!/bin/bash

sudo apt update
sudo apt install nginx -y

rm /var/www/html/*.html

cat > /var/www/html/index.html <<EOF
<h1>AWS Webserver to RDS connection</h1>
<p>DB Addresss: ${db_address}</p>
<p>DB Port: ${db_port}</p>
EOF
