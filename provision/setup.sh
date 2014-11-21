#!/bin/sh

DRUPAL_SRC="http://ftp.drupal.org/files/projects/drupal-8.0.0-beta3.tar.gz";

# update base system
APT_LOCK="/vagrant/provision/apt.lock";
if [ ! -e  $APT_LOCK ]
then
    apt-get update
    apt-get upgrade -y
    touch $APT_LOCK
fi

# install useful tools
if [ ! -e "/usr/bin/debconf-set-selections" ]
then
    apt-get install -y debconf-utils
fi

if [ ! -e "/usr/bin/vim" ]
then
    apt-get install -y vim
fi

if [ ! -e "/usr/bin/wget" ]
then
    apt-get install -y wget
fi

if [ ! -e "/etc/apache2" ]
then
    echo "Installing Apache"
    apt-get install -y apache2
    a2enmod rewrite
    cp /vagrant/provision/apache2-envvars /etc/apache2/envvars
    sudo chown vagrant /var/lock/apache2
    usermod -a -G adm vagrant
fi

# install php5
if [ ! -e "/usr/bin/php" ]
then
    echo "Installing PHP 5"
    apt-get install -y php5 php-pear php5-mysql php5-gd
fi

# install mysql
if [ ! -e "/etc/mysql/my.cnf" ]
then
    echo "mysql-server-5.5 mysql-server/root_password_again password super-mysql" | debconf-set-selections
    echo "mysql-server-5.5 mysql-server/root_password password super-mysql" | debconf-set-selections
    apt-get install -y mysql-server mysql client

    echo "Installing MySQL"
    echo "Create database drupal8" | mysql -u root -psuper-mysql
    echo "GRANT ALL ON drupal8.* to drupal8@localhost identified by 'super-drupal'" | mysql -u root -psuper-mysql
fi

# download drupal
if [ ! -e "/vagrant/web/" ]
then
    echo "Downloading Drupal 8"
    mkdir /vagrant/web/
    cd /vagrant/web/
    wget --quiet $DRUPAL_SRC
    tar --strip-components=1 -xzf `basename $DRUPAL_SRC`
    rm drupal-8.0.0-beta3.tar.gz
    rm /vagrant/web/sites/default/default.settings.php
fi

# setup vhost
if [ ! -e "/etc/apache2/sites-available/drupal8" ]
then
    echo "copying virtual host"
    cp /vagrant/provision/vhost.conf /etc/apache2/sites-available/drupal8
    sudo a2ensite drupal8
    /etc/init.d/apache2 reload
fi

if [ ! -e "/etc/php5/apache2/php.ini" ]
then
    echo "Copying php.ini"
    cp /vagrant/provision/php.ini /etc/php5/apache2/php.ini
    /etc/init.d/apache2 reload
fi


if [ ! -e "/vagrant/web/sites/default/default.settings.php" ]
then
    echo "Copying default settings."
    cp /vagrant/provision/default.settings.php /vagrant/web/sites/default/default.settings.php
fi