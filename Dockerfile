# syntax=docker/dockerfile:1
FROM php:8.2-apache

# Use production php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Enable modules we need
RUN a2enmod rewrite headers

# Silence the ServerName warning
RUN printf "ServerName localhost\n" > /etc/apache2/conf-available/servername.conf \
 && a2enconf servername

# ──────────────────────────────────────────────────────────────
# Docroot config:
#   • Default: /var/www/html (root docroot)
#   • If your app uses /public: UNCOMMENT the 3 lines below
# ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
# RUN sed -ri 's!DocumentRoot /var/www/html!DocumentRoot ${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
#  && sed -ri 's!<Directory /var/www/html>!<Directory ${APACHE_DOCUMENT_ROOT}>!g' /etc/apache2/apache2.conf
# ──────────────────────────────────────────────────────────────

# Allow .htaccess overrides and set index preference
RUN printf "DirectoryIndex index.php index.html\n" > /etc/apache2/conf-available/dirindex.conf \
 && a2enconf dirindex \
 && printf "<Directory /var/www/html>\n  AllowOverride All\n  Require all granted\n</Directory>\n" \
      > /etc/apache2/conf-available/override.conf \
 && a2enconf override

# Copy app
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Tiny health endpoint (useful on Railway/Render/K8s)
RUN printf '%s\n' "<?php http_response_code(200); header('Content-Type: text/plain'); echo 'OK';" > /var/www/html/healthz.php

EXPOSE 80
CMD ["apache2-foreground"]
