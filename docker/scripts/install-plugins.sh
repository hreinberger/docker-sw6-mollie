
cd /var/www/html && composer require basecom/sw6-fixtures-plugin:3.0.0
cd /var/www/html && composer require store.shopware.com/molliepayments

cd /var/www/html && php bin/console --no-debug cache:clear
cd /var/www/html && php bin/console --no-debug plugin:list
cd /var/www/html && php bin/console --no-debug plugin:refresh

cd /var/www/html && php bin/console --no-debug plugin:install --activate BasecomFixturePlugin
cd /var/www/html && php bin/console --no-debug plugin:install --activate MolliePayments

cd /var/www/html && php bin/console --no-debug cache:clear
