#!/bin/bash

set -e

source /etc/apache2/envvars
source /var/www/.bashrc

export BASH_ENV=/var/www/.bashrc


if [ $MOLLIE_TEST_API_KEY != '' ]; then
  sudo service mysql start;
  cd /var/www/html && php bin/console --no-debug system:config:set MolliePayments.config.testApiKey "$MOLLIE_TEST_API_KEY"
  sudo service mysql stop;
fi


if [ $MOLLIE_WEBHOOK_DOMAIN != '' ]; then
    echo "MOLLIE_SHOP_DOMAIN=$MOLLIE_WEBHOOK_DOMAIN" >> /var/www/html/.env
else
    # we set a custom webhook domain for the plugin, otherwise payments with localhost do not work ;)
    echo "MOLLIE_SHOP_DOMAIN=local.mollie.com" >> /var/www/html/.env
fi


exec "$@"
