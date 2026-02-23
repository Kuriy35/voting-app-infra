#!/bin/bash
yum update -y
yum install -y redis6

sed -i 's/^bind 127.0.0.1 -::1/bind 0.0.0.0/' /etc/redis6/redis6.conf
sed -i 's/^bind 127.0.0.1/bind 0.0.0.0/' /etc/redis6/redis6.conf
sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis6/redis6.conf

systemctl start redis6
systemctl enable redis6