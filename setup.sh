#!/bin/sh

#apt-get update
#apt-get upgrade -y

# install apache
apt-get install -y debconf-utils vim wget

echo "mysql-server-5.5 mysql-server/root_password_again password super-mysql" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password password super-mysql" | debconf-set-selections

apt-get install -y apache2 mysql-server mysql-client
a2enmod rewrite
cp /vagrant/provision/apache2-envvars /etc/apache2/envvars

# install php5
apt-get install -y php5 php-pear php5-mysql php5-gd

# install mysql
apt-get install -y mysql-server

echo "Create database drupal8" | mysql -u root -psuper-mysql
echo "GRANT ALL ON drupal8.* to drupal8@localhost identified by 'super-drupal'" | mysql -u root -psuper-mysql

# setup vhost
cp /vagrant/provision/vhost.conf /etc/apache2/sites-available/drupal8
a2ensite drupal8

cp /vagrant/provision/php.ini /etc/php5/apache2/php.ini
/etc/init.d/apache2 restart

# download drupal
#cd /vagrant/web/
#wget http://ftp.drupal.org/files/projects/drupal-8.0.0-beta3.tar.gz
#tar --strip-components=1 -xzf drupal-8.0.0-beta3.tar.gz
#rm drupal-8.0.0-beta3.tar.gz

cp /vagrant/provision/default.settings.php /vagrant/web/sites/default/default.settings.php