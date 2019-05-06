#!/bin/bash
apt-get -y update
apt-get -y install nginx
apt-get -y install awscli

aws s3 cp s3://nginx-configuration-lesson1/default.conf /etc/nginx/nginx.conf
aws s3 cp s3://nginx-configuration-lesson1/index.html /var/www/html/index.html

service nginx restart