
cd /var/www/html && composer require store.shopware.com/molliepayments

git clone -b master https://github.com/basecom/FixturesPlugin /var/www/html/custom/plugins/FixturesPlugin

cd /var/www/html && php bin/console --no-debug cache:clear
cd /var/www/html && php bin/console --no-debug plugin:list
cd /var/www/html && php bin/console --no-debug plugin:refresh

cd /var/www/html && php bin/console --no-debug plugin:install --activate BasecomFixturePlugin
cd /var/www/html && php bin/console --no-debug plugin:install --activate MolliePayments

cd /var/www/html && php bin/console --no-debug cache:clear
