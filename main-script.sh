#! /bin/bash

date
cd /root
apt update
apt install -y mariadb-server
apt install -y apache2
apt install -y php php-curl php-json php-mysql php-imagick php-mbstring php-xml php-zip php-memcached php-redis php-bcmath php-intl imagemagick ghostscript
date
