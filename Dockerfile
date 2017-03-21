FROM alpine:3.5
MAINTAINER Davin Bao <davin.bao@gmail.com>

RUN set -x \
    && addgroup -g 1982 -S www \
    && adduser -u 1982 -D -S -G www www
	
RUN set -xe \
    && echo 'http://alpine.gliderlabs.com/alpine/edge/testing' >> /etc/apk/repositories \
    && apk update \
    && apk add curl \
	git
	
#install nginx
RUN set -xe \
    && apk add nginx
	
#install php7 php7-fpm
RUN set -xe \
    && apk add php7 \
    php7-openssl \
    php7-mcrypt \
    php7-soap \
    php7-gmp \
    php7-json \
    php7-dom \
    php7-pdo \
    php7-zip \
    php7-mysqli \
    php7-sqlite3 \
    php7-pdo_pgsql \
    php7-bcmath \
    php7-gd \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-gettext \
    php7-xmlreader \
    php7-xmlrpc \
    php7-bz2 \
    php7-iconv \
    php7-pdo_dblib \
    php7-curl \
    php7-ctype \
    php7-pear \
    php7-xsl \
    php7-zlib \
    php7-mbstring \
    php7-opcache \
    php7-pcntl \
    php7-sockets \
    php7-sysvsem \
    php7-xml \
    php7-redis \
	php7-phar \
    php7-fpm
	
#install composer
RUN set -xe \
    && cd /home/www \
    && curl -sS https://getcomposer.org/installer | php7
    
RUN set -xe \
    && mkdir -p /home/www/logs/nginx \
    && mkdir -p /home/www/logs/php-fpm    
    
RUN set -xe \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
	fastcgi_temp_file_write_size 128k;
    && echo "pid /var/run/nginx.pid;" >> /etc/nginx/nginx.conf \
    && sed -i 's/user nginx;/user www;/g' /etc/nginx/nginx.conf \
    && sed -i 's/worker_connections 1024;/worker_connections 4096;/g' /etc/nginx/nginx.conf \
    && sed -i 's/client_max_body_size 1m;/client_max_body_size 2G;/g' /etc/nginx/nginx.conf \
    && sed -i 's/client_max_body_size 2G;/client_max_body_size 2G;fastcgi_connect_timeout 300;fastcgi_send_timeout 300;fastcgi_read_timeout 300;fastcgi_buffer_size 64k;fastcgi_buffers 4 64k;fastcgi_busy_buffers_size 128k;/g' /etc/nginx/nginx.conf \
    && sed -i 's/include \/etc\/nginx\/mime\.types;/include \/etc\/nginx\/mime\.types\;include \/etc\/nginx\/fastcgi\.conf\;/g' /etc/nginx/nginx.conf \
    && sed -i 's/include \/etc\/nginx\/conf.d\/\*\.conf\;/include \/home\/www\/conf\/\*\.conf\;/g' /etc/nginx/nginx.conf
	
    
RUN set -xe \
    && sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /etc/php7/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /etc/php7/php.ini \
    && sed -i 's/;date.timezone =/date.timezone = UTC/g' /etc/php7/php.ini \
    && sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini \
    && sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php7/php.ini \
    && sed -i 's/;pid = run\/php\-fpm7\.pid/pid = \/var\/run\/php\-fpm7\.pid/g' /etc/php7/php-fpm.conf \
    && sed -i 's/;error_log = log\/php7\/error\.log/error_log = \/home\/www\/logs\/php-fpm\/error\.log/g' /etc/php7/php-fpm.conf \
    && sed -i 's/;log_level = notice/log_level = warning/g' /etc/php7/php-fpm.conf \
    && sed -i 's/user = nobody/user = www/g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = www/g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's/;listen.owner = nobody/listen.owner = www/g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's/;listen.group = nobody/listen.group = www/g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's/;chdir = \/var\/www/chdir = \/home\/www/g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's/;php_admin_value\[memory_limit\] = 32M/php_admin_value\[memory_limit\] = 128M/g' /etc/php7/php-fpm.d/www.conf \
    && sed -i 's/;php_flag\[display_errors\] = off/php_flag\[display_errors\] = on/g' /etc/php7/php-fpm.d/www.conf \
    && echo "php_admin_value[upload_max_filesize] = 2G" >> /etc/php7/php-fpm.d/www.conf \
    && echo "php_admin_value[post_max_size] = 2G" >> /etc/php7/php-fpm.d/www.conf \
    && echo "php_admin_value[always_populate_raw_post_data] = -1" >> /etc/php7/php-fpm.d/www.conf \
    && echo "php_admin_value[output_buffering] = 0" >> /etc/php7/php-fpm.d/www.conf \
    && echo "php_admin_value[php_value max_input_time] = 3600" >> /etc/php7/php-fpm.d/www.conf \
    && echo "php_admin_value[php_value max_execution_time] = 3600" >> /etc/php7/php-fpm.d/www.conf
    
ADD run.sh /
RUN chmod +x /run.sh

EXPOSE 80
VOLUME ["/home/www"]

CMD ["/run.sh"]
