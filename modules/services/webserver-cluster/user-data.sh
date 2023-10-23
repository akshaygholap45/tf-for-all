#!/bin/bash

cat > index.xhtml <<EOF
<h1>Hello, Worls</h1>
<p>DB Addresss: ${db_address}</p>
<p>DB Port: ${db_port}</p>
EOF
nohup busybox httpd -f -p ${server_port} &