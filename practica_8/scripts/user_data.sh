#!/bin/bash
echo "Este es un mensaje" > ~/mensaje.txt
yum update -y
yum install httpd -y
systemctl enable http
systemctl start httpd