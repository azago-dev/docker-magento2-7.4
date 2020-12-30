FROM php:7.4.12-apache

MAINTAINER Andre Zago <andrezago88@gmail.com>

ENV XDEBUG_PORT 9000

# Install System Dependencies


RUN apt-get update && apt-get install -y wget gnupg g++ locales unzip dialog apt-utils git && apt-get clean

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils \	
	software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libfreetype6-dev \
	libicu-dev \
  	libssl-dev \
  	libmcrypt-dev \
  	libzip-dev \
  	libonig-dev \
	libjpeg62-turbo-dev \	
	libpng-dev \
	libjpeg-dev \
	libedit-dev \
	libedit2 \
	libxslt1-dev \		
	redis-tools \
	mariadb-client \
	git \
	vim \
	wget \
	curl \
	lynx \
	psmisc \
	unzip \
	tar \
	cron \
	bash-completion \
	&& apt-get clean

# Install Magento Dependencies

RUN docker-php-ext-configure \
  	gd --with-freetype --with-jpeg; \
  	docker-php-ext-install \
  	opcache \
  	gd \
  	bcmath \
  	intl \  	
  	pdo_mysql \
  	soap \
  	xsl \
  	zip \
  	sockets

# Install oAuth

RUN apt-get update \
  	&& apt-get install -y \
  	libpcre3 \
  	libpcre3-dev \
  	# php-pear \
  	&& pecl install oauth \
  	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini \
  	&& echo "memory_limit=8G" > /usr/local/etc/php/conf.d/docker-php-ext-memlimit.ini

# Install Composer

RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer --version=1.10.17

# Install Code Sniffer

RUN git clone https://github.com/magento/marketplace-eqp.git /var/www/marketplace-eqp
RUN cd /var/www/marketplace-eqp && composer install
RUN chmod +x /var/www/marketplace-eqp/vendor/bin/phpcs
RUN ln -s /var/www/marketplace-eqp/vendor/bin/phpcs /usr/local/bin;

ENV PATH="/var/www/.composer/vendor/bin/:${PATH}"

# Install XDebug

RUN yes | pecl install xdebug-2.8.0 && \
	 echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.iniOLD

# Install Mhsendmail

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

# Install Magerun 2

RUN wget https://files.magerun.net/n98-magerun2.phar \
	&& chmod +x ./n98-magerun2.phar \
	&& mv ./n98-magerun2.phar /usr/local/bin/

# Configuring system

ADD .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/magento.conf /etc/apache2/sites-available/magento.conf
COPY .docker/config/custom-xdebug.ini /usr/local/etc/php/conf.d/custom-xdebug.ini
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
RUN chmod +x /usr/local/bin/*
RUN ln -s /etc/apache2/sites-available/magento.conf /etc/apache2/sites-enabled/magento.conf

RUN curl -o /etc/bash_completion.d/m2install-bash-completion https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install-bash-completion
RUN curl -o /etc/bash_completion.d/n98-magerun2.phar.bash https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash
RUN echo "source /etc/bash_completion" >> /root/.bashrc
RUN echo "source /etc/bash_completion" >> /var/www/.bashrc

RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html
