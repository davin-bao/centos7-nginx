## PHP7-FPM & Nginx Docker Image
Lightwight Docker image for the PHP7-FPM and Nginx based on AlpineLinux:3.5

Image size only ~100MB !

Very new packages (alpine:3.5):

PHP 7.0.16

Nginx 1.10.3

## Usage

sudo docker run -v /htdocs:/home/www -p 80:80 davin-bao/nginx-php7

## Volume structure

htdocs: Webroot

index file: htdocs/public/index.php

logs: Nginx/PHP error logs

conf: Nginx vhost file
