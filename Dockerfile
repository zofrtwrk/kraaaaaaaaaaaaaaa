# syntax=docker/dockerfile:1
FROM php:8.2-apache

# Production php.ini (optional)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Enable useful modules
RUN a2enmod rewrite headers

# Silence the ServerName warning
RUN printf "ServerName localhost\n" > /etc/apache2/conf-available/servername.conf \
 && a2enconf servername

# (If your app uses /public as docroot, uncomment the next 3 lines)
# ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
# RUN sed -ri 's!DocumentRoot /var/www/html!DocumentRoot ${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
#  && sed -ri 's!<Directory /var/www/html>!<Directory ${APACHE_DOCUMENT_ROOT}>!g' /etc/apache2/apache2.conf

# Copy your app
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
