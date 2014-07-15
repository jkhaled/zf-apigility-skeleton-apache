#!/bin/bash -e
#
# vagrant_bootstrap.sh - script run upon instance start up
#
#   This script is responsible for installing and configuring
#   necessary packages for Apigility API server.
#
#   Note that the script needs to be able to be repeatably run
#   without errors.
#
# Author: EMCP <emcp@whichdegree.co>

# inform apt that there's no user to answer interactive questions
export DEBIAN_FRONTEND=noninteractive

if [ -z "$1" ]; then
  echo "\$apigilityAPI_Dir_root missing. [Usage] \$image_bootstrap.sh [apigility_api_root_dir]"
  exit -1
else
  echo "\$apigilityAPI_Dir_root = " "$1"
fi

echo "__________________STARTING image_bootstrap.sh_______________"

echo -n "Updating source package lists          ... "
# update sources list
apt-get -qq update
echo "done"

echo -n "Checking utilities                     ... "
# install some useful command line utilities as necessary
apt-get -qqy install vim-nox git grep tmux mosh wget curl net-tools unzip python-software-properties nfs-common portmap
echo "done"

echo -n "Checking apache                        ... "
apt-get -qqy install apache2
echo "done"

echo "Checking php5                          ... "
apt-get -qqy install libapache2-mod-php5 php5-cli php5-mysqlnd php5-xdebug
echo "done"

#DEFAULT CONF FILE used with Vagrant
NEW_CONF_FILE="$1"/.devops/apigility-sandbox.local.conf

if [ "$1" == "/vagrant" ]; then
  echo "using default conf file with Apache. " ${NEW_CONF_FILE}
fi

echo -n "Checking apache.conf setup with " ${NEW_CONF_FILE} "\n"
if [ ! -f /etc/apache2/sites-available/apigility-sandbox.local.conf ]; then
    ln -sf $NEW_CONF_FILE /etc/apache2/sites-available/apigility-sandbox.local.conf
    sed -i '/127.0.0.1\slocalhost/a 127.0.0.1\tapigility-sandbox.local' /etc/hosts
    sed -i '/Listen 80/a Listen 8888' /etc/apache2/ports.conf
    #a2dissite default
    a2enmod rewrite
    a2ensite apigility-sandbox.local
fi
echo "done"

echo -n "Restarting the apache2 service"
service apache2 restart
echo "done"
