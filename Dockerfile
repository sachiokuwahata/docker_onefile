FROM php:7.3-fpm
COPY ./docker/php/php.ini /usr/local/etc/php/

RUN apt-get update && apt-get -y upgrade

RUN apt-get install -y nginx
COPY ./docker/nginx/default.conf etc/nginx/conf.d/default.conf


RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN apt-get install -y unzip
RUN apt-get install -y zip
RUN docker-php-ext-install pdo_mysql zip
RUN apt-get install -y zip
RUN apt-get install -y wget

#supervisor
RUN apt-get update && apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#Composer install
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer

ENV PATH $PATH:/composer/vendor/bin


#
WORKDIR /var/www/html


RUN composer global require "laravel/installer"
RUN composer create-project --prefer-dist laravel/laravel app

COPY test.php /var/www/html/app/public/test.php



EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/conf.d/supervisord.conf"]

