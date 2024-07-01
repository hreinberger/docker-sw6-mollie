
# little hack to allow fixtures auto-loading.
# the mollie plugin checks if dev-deps are installed by checking for the phpunit binary.
# only then, fixtures are available
mkdir -p /var/www/html/vendor/store.shopware.com/molliepayments/vendor/bin
touch /var/www/html/vendor/store.shopware.com/molliepayments/vendor/bin/phpunit

# make sure all our file permissions for the new hacks are correct
sudo chown 33:33 /var/www/html/vendor/store.shopware.com/molliepayments -R
sudo chmod 775 /var/www/html/vendor/store.shopware.com/molliepayments -R

# clear cache and run fixtures
cd /var/www/html && rm -rf var/cache
cd /var/www/html && php bin/console --no-debug fixture:load:group mollie