#! /bin/bash 

docker run --name ip_site -p 6071:80 -p 6072:443 \
-d --restart=always \
-v /Users/andyge/Desktop/lesson/https_cert/site/html:/usr/share/nginx/html \
-v /Users/andyge/Desktop/lesson/https_cert/site/cert:/etc/nginx/cert \
-v /Users/andyge/Desktop/lesson/https_cert/site/logs:/var/log/nginx \
-v /Users/andyge/Desktop/lesson/https_cert/site/conf.d:/etc/nginx/conf.d \
nginx 
