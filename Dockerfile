FROM php:8.2-apache

# Install lightweight SMTP client for PHP mail()
RUN apt-get update \
 && apt-get install -y --no-install-recommends msmtp ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Configure PHP to use msmtp as sendmail
RUN echo "sendmail_path = /usr/sbin/msmtp -t -i" > /usr/local/etc/php/conf.d/sendmail.ini

# Emit structured access logs with latency to stdout
RUN set -eux; \
    { \
      echo 'LogFormat "ts=%{%Y-%m-%dT%H:%M:%S%z}t client=%a forwardedfor=\\"%{X-Forwarded-For}i\\" host=%v method=%m uri=%U query=\\"%q\\" protocol=%H status=%>s bytes=%O referer=\\"%{Referer}i\\" agent=\\"%{User-Agent}i\\" response_time_us=%D" logreq'; \
    } > /etc/apache2/conf-available/logging.conf \
 && a2enconf logging \
 && a2disconf other-vhosts-access-log \
 && sed -i '/CustomLog /d;/ErrorLog /d' /etc/apache2/sites-available/000-default.conf \
 && { \
      echo 'ErrorLog /proc/self/fd/2'; \
      echo 'CustomLog /proc/self/fd/1 logreq'; \
    } >> /etc/apache2/sites-available/000-default.conf

# Copy site into the Apache web root
COPY . /var/www/html/

# Entrypoint to template msmtp config from env vars, then hand off to stock PHP entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

# Expose HTTP port
EXPOSE 80
