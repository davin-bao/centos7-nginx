#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ ! -d /home/www ] ; then
  mkdir -p /home/www
  chown www:www /home/www
fi

# composer dump
echo "192.168.4.119 packagist.local.com" >>/etc/hosts
cd /home/www && php7 composer.phar dump-autoload

# start php-fpm
mkdir -p /home/www/logs/php-fpm
php-fpm7

# start nginx
mkdir -p /home/www/logs/nginx
mkdir -p /tmp/nginx
chown www /tmp/nginx
nginx
