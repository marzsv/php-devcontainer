FROM php:8.1

# Install platform dependencies
RUN apt-get update && apt-get install -y zlib1g-dev libpng-dev libjpeg62-turbo-dev \
    libfreetype6-dev gettext autoconf make vim git openssh-client zsh \
    libmcrypt-dev bash less docker python3 python3-dev python3-pip \
    libffi-dev groff redis-server build-essential g++ locales-all tzdata


# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel botocore awscli localstack

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo pdo_mysql gd gettext exif pcntl bcmath sockets

RUN printf "\n" | pecl install redis && \
    printf "\n" | pecl install mcrypt-1.0.5 && \
    printf "\n" | pecl install xdebug-3.2.0 && \
    # xdebug doesn't need to be enabled manually. Because is being enabled mouting the file in the docker-compose.yml
    echo "extension=redis.so" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini && \
    echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer setup.php');" \
    && cp composer.phar /usr/local/bin/composer

# Install FZF
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# Install php-cs-fixer globally and add the global composer bin to the path
RUN composer global require friendsofphp/php-cs-fixer
