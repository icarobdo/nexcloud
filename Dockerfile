FROM ubi8/php-74

EXPOSE 8080
EXPOSE 8443

ENV PHP_VERSION=7.4 \
    PHP_VER_SHORT=74 \
    NAME=php

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

RUN yum -y module enable php:$PHP_VERSION && \
    INSTALL_PKGS="php php-apcu php-bz2 php-ctype php-curl php-mysqlnd php-pgsql php-sqlite3 php-bcmath \
                  php-gd php-dom php-exif php-fileinfo php-intl php-json php-ldap php-mbstring php-xmlreader php-pdo \
                  php-process php-ftp php-soap php-dev php-iconv php-opcache php-xml php-imagick php-zip php-imap \
                  php-gmp php-mcrypt php-pecl-apcu php-memcachedphp-pecl-zip mod_ssl hostname curl php-opcache \
				  php-pcntl php-pdo_mysql php-pdo_pgsql php-pdo_sqlite php-phar php-posix php-redis php-sodium \
				  ffmpeg autoconf automake gnu-libiconv imagemagick libxml2 samba-client sudo tar unzip file g++\ 
				  gcc make re2c samba-dev zlib-dev " && \
				  
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum reinstall -y tzdata && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

ENV PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php/ \
    APP_DATA=${APP_ROOT}/src \
    PHP_DEFAULT_INCLUDE_PATH=/usr/share/pear \
    PHP_SYSCONF_PATH=/etc \
    PHP_HTTPD_CONF_FILE=php.conf \
    HTTPD_CONFIGURATION_PATH=${APP_ROOT}/etc/conf.d \
    HTTPD_MAIN_CONF_PATH=/etc/httpd/conf \
    HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d \
    HTTPD_MODULES_CONF_D_PATH=/etc/httpd/conf.modules.d \
    HTTPD_VAR_RUN=/var/run/httpd \
    HTTPD_DATA_PATH=/var/www \
    HTTPD_DATA_ORIG_PATH=/var/www \
    HTTPD_VAR_PATH=/var

#download nextcloud
RUN wget https://download.nextcloud.com/server/releases/latest.zip && unzip latest.zip -d /var/www/html
RUN mkdir /var/www/html/nextcloud/data && chown -R apache:apache /var/www/html/nextcloud/* && chcon -t httpd_sys_rw_content_t /var/www/html/nextcloud/ -R
