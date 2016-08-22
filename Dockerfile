# This is a comment
FROM centos:7
MAINTAINER Davin Bao <davin.bao@gmail.com>

RUN yum -y update --nogpgcheck; yum clean all

#Install nginx repo
RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

# Install latest version of nginx
RUN yum install -y nginx --nogpgcheck

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/etc/nginx/conf.d/"]

EXPOSE 80 443
CMD ["nginx"]
