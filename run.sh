#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /home/www ] ; then
  mkdir -p /home/www
  chown www:www /home/www
fi

# start php-fpm
mkdir -p /home/www/logs/php-fpm
php-fpm7

# start nginx
mkdir -p /home/www/logs/nginx
mkdir -p /tmp/nginx
chown www /tmp/nginx
nginx
