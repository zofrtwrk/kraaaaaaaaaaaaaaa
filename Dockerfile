# syntax=docker/dockerfile:1
FROM php:8.2-apache

# Production PHP + modules
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && a2enmod rewrite headers

# Silence ServerName warning
RUN printf "ServerName localhost\n" > /etc/apache2/conf-available/servername.conf && a2enconf servername

# Make Apache honor .htaccess and ensure index.php is used
RUN printf "DirectoryIndex index.php index.html\n" > /etc/apache2/conf-available/dirindex.conf \
 && a2enconf dirindex \
 && printf "<Directory /var/www/html>\n  AllowOverride All\n  Require all granted\n</Directory>\n" \
      > /etc/apache2/conf-available/override.conf \
 && a2enconf override

# Copy your app
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
