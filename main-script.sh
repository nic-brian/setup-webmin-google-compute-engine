#! /bin/bash

date
cd /root
apt update
apt install -y mariadb-server
apt install -y apache2
apt install -y php php-curl php-json php-mysql php-imagick php-mbstring php-xml php-zip php-memcached php-redis php-bcmath php-intl imagemagick ghostscript libdbd-mysql-perl
curl -o setup-webmin.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
echo y | sh setup-webmin.sh
apt install -y webmin
a2enmod -q ssl
a2enmod -q rewrite
systemctl restart apache2
apt install -y snapd
snap install core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
gcloud compute firewall-rules create default-allow-webmin --action allow --target-tags webmin-server --source-ranges 0.0.0.0/0 --rules tcp:10000
date
