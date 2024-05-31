
cd /var/www/html && composer require store.shopware.com/molliepayments

git clone -b main https://github.com/basecom/FixturesPlugin /var/www/html/custom/plugins/FixturesPlugin
## TODO: remove the checkout, we need it currently for 6.6.2.0
cd /var/www/html/custom/plugins/FixturesPlugin && git checkout feature/never-vendor-again

cd /var/www/html && php bin/console --no-debug cache:clear
cd /var/www/html && php bin/console --no-debug plugin:list
cd /var/www/html && php bin/console --no-debug plugin:refresh

cd /var/www/html && php bin/console --no-debug plugin:install --activate BasecomFixturePlugin
cd /var/www/html && php bin/console --no-debug plugin:install --activate MolliePayments

cd /var/www/html && php bin/console --no-debug cache:clear
