
# we dont need the basecom plugin anymore after fixtures exist
cd /var/www/html && php bin/console --no-debug plugin:uninstall BasecomFixturePlugin
rm -rf /var/www/html/custom/plugins/FixturesPlugin

# remove our temp folders
sudo rm -rf /mollie
sudo rm -rf /scripts

# and finally clear the cache again
sudo rm -rf /var/www/html/var/cache
cd /var/www/html && php bin/console --no-debug cache:clear