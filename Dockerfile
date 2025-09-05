# syntax=docker/dockerfile:1
FROM php:8.2-apache

# Optional: use production PHP settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && sed -i "s|;date.timezone =|date.timezone = UTC|" "$PHP_INI_DIR/php.ini"

# Enable useful Apache modules
RUN a2enmod rewrite headers

# Copy your PHP site into the Apache doc root
COPY . /var/www/html

# Ownership & perms (safe default)
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
