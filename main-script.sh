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

# open firewall for Webmin port
gcloud compute firewall-rules create default-allow-webmin --action allow --target-tags webmin-server --source-ranges 0.0.0.0/0 --rules tcp:10000

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
pushd /etc/webmin
sed -i /keyfile=/s@.\*@keyfile=/etc/letsencrypt/live/${vhost::-1}/privkey.pem@ miniserv.conf
echo certfile=/etc/letsencrypt/live/${vhost::-1}/fullchain.pem >>miniserv.conf
systemctl restart webmin
popd

# create wordpress database, user, and permissions
mariadb -e 'create database wp1;'
mariadbpw=`tr -dc A-Za-z0-9 </dev/urandom | head -c 20`
mariadb -e "create user user1@localhost identified by '$mariadbpw';"
mariadb -e 'grant all privileges on wp1.* to user1@localhost;'

# update root password
rootpw=`tr -dc A-Za-z0-9 </dev/urandom | head -c 20`
yes $rootpw | passwd

# output summary information
echo ********** IMPORTANT INFORMATION **********
echo Webmin username: root
echo Webmin password: $rootpw
echo Webmin URL: https://${vhost::-1}:10000
echo WordPress database username: user1
echo WordPress database password: $mariadbpw
echo WordPress database: wp1
echo WordPress database host: localhost
echo WordPress URL: https://${vhost::-1}
echo *******************************************

date
