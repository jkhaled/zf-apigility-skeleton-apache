#!/bin/bash -e
#
#   apigility_bootstrap.sh - script run upon instance start up
#
#   This script is responsible for installing and configuring
#   necessary packages for Apigility server.
#
#   Note that the script needs to be able to be repeatably run
#   without errors.
#
# Author: EMCP <emcp@whichdegree.co>

# inform apt that there's no user to answer interactive questions
export DEBIAN_FRONTEND=noninteractive

echo "__________________STARTING apigility_bootstrap.sh_______________"

echo "Updating source package lists          ... "
# update sources list
apt-get -qq update
echo "done"

echo -n "checking if zend framework is deployed & enabling dev mode         ... "
cd /vagrant
php composer.phar self-update
php composer.phar install
php public/index.php development enable
cd /
echo "done"


echo -n "restarting apache2"
service apache2 restart
echo "done"
