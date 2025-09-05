# Dockerfile
FROM php:8.2-apache

# Optional PHP extensions you actually need:
# RUN docker-php-ext-install pdo_mysql

# Copy app into webroot
COPY . /var/www/html

# Enable rewrites + silence ServerName warning + sane defaults
RUN a2enmod rewrite \
 && printf "ServerName localhost\n" > /etc/apache2/conf-available/servername.conf \
 && a2enconf servername \
 && printf "<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    <Directory /var/www/html>\n\
        AllowOverride All\n\
        Require all granted\n\
        DirectoryIndex index.php index.html\n\
    </Directory>\n\
</VirtualHost>\n" > /etc/apache2/sites-available/000-default.conf

EXPOSE 80
CMD ["apache2-foreground"]
