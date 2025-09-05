# Dockerfile (Laravel/public)
FROM php:8.2-apache

# Optional: add extensions you actually use
# RUN docker-php-ext-install pdo_mysql

# Copy code
COPY . /var/www/html

# Point Apache to /public and enable rewrites
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN a2enmod rewrite && \
    sed -ri "s#DocumentRoot /var/www/html#DocumentRoot ${APACHE_DOCUMENT_ROOT}#g" /etc/apache2/sites-available/000-default.conf && \
    sed -ri "s#<Directory /var/www/html/>#<Directory ${APACHE_DOCUMENT_ROOT}/>#g" /etc/apache2/apache2.conf && \
    printf "<Directory ${APACHE_DOCUMENT_ROOT}>\n\
        AllowOverride All\n\
        Require all granted\n\
        DirectoryIndex index.php index.html\n\
    </Directory>\n" >> /etc/apache2/apache2.conf

EXPOSE 80
CMD ["apache2-foreground"]
