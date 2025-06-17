FROM debian:bookworm

# Install core services and PHP 8.2
RUN apt-get update && \
    apt-get install -y \
    sshpass openssh-client \
    nginx \
    nano \
    openssh-server \
    php8.2 \
    php8.2-fpm \
    php8.2-sqlite3 \
    php8.2-mbstring \
    php8.2-zip \
    php8.2-bcmath \
    php8.2-tokenizer \
    php-mysql \
    php-xml \
    php-curl \
    php-cli \
    mariadb-server \
    npm \
    composer \
    git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup SSH and create necessary directories
RUN echo "root:P@ssw0rd1" | chpasswd && ssh-keygen -A

# Create root home directory and .ansible directory with proper permissions
RUN mkdir -p /root/.ansible/tmp && \
    chmod 755 /root && \
    chmod 700 /root/.ansible && \
    chmod 755 /root/.ansible/tmp

# Ensure PHP-FPM socket dir exists
RUN mkdir -p /run/php

# Copy custom nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

# Start services
CMD service ssh start && service php8.2-fpm start && nginx -g 'daemon off;'
