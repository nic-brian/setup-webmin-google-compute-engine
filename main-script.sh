#! /bin/bash

date
cd /root
apt update

# set up a generic domain name for this instance
vhost=`curl https://dgl-dns-wzwqo2bdfa-uw.a.run.app/`

# get user's email address
echo What is your email address?
read email

# install required packages
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install
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

# install wordpress
pushd /var/www
wget https://wordpress.org/latest.zip
unzip latest.zip
chown -R www-data:www-data wordpress
popd

# create virtual host
pushd /etc/apache2/sites-available
cat <<EOF >${vhost}conf
<VirtualHost *:80>
    DocumentRoot "/var/www/wordpress"
    ServerName ${vhost::-1}
    <Directory "/var/www/wordpress">
        Options None
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2ensite ${vhost}conf
systemctl reload apache2
popd

# provision TLS certificate
certbot --apache -n --no-eff-email --agree-tos -m $email -d ${vhost::-1}

# configure Webmin with new TLS certificate
# TODO

# create wordpress database, user, and permissions
# TODO


# open firewall for Webmin port
gcloud compute firewall-rules create default-allow-webmin --action allow --target-tags webmin-server --source-ranges 0.0.0.0/0 --rules tcp:10000
date
passwd
