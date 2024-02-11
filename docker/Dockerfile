FROM dockware/play:latest

# The tests folder is excluded at the moment
# so we have a local backup and copy the fixtures to the container
ADD tests /mollie/fixes/tests

RUN sudo service mysql start && \
	git clone -b master https://github.com/basecom/FixturesPlugin /var/www/html/custom/plugins/FixturesPlugin && \
    cd /var/www/html && composer config repositories.shopware-packages '{ "type": "composer", "url": "https://packages.shopware.com" }' && \
    cd /var/www/html && composer config bearer.packages.shopware.com "test" && \
    cd /var/www/html && composer require store.shopware.com/molliepayments && \
	cd /var/www/html && php bin/console --no-debug cache:clear && \
	cd /var/www/html && php bin/console --no-debug plugin:list && \
	cd /var/www/html && php bin/console --no-debug plugin:refresh && \
	cd /var/www/html && php bin/console --no-debug plugin:install --activate BasecomFixturePlugin && \
	cd /var/www/html && php bin/console --no-debug plugin:install --activate MolliePayments && \
	cd /var/www/html && php bin/console --no-debug cache:clear && \
    # --------------------------------------------------------------------------------
    sudo chown 33:33 /mollie -R && \
    sudo chmod 775 /mollie -R && \
    mv /mollie/fixes/tests /var/www/html/vendor/store.shopware.com/molliepayments && \
	mkdir -p /var/www/html/vendor/store.shopware.com/molliepayments/vendor/bin && \
	touch /var/www/html/vendor/store.shopware.com/molliepayments/vendor/bin/phpunit && \
    sudo chown 33:33 /var/www/html/vendor/store.shopware.com/molliepayments -R && \
    sudo chmod 775 /var/www/html/vendor/store.shopware.com/molliepayments -R && \
	cd /var/www/html && rm -rf var/cache && \
	cd /var/www/html && php bin/console --no-debug fixture:load:group mollie && \
    # --------------------------------------------------------------------------------
	cd /var/www/html && php bin/console --no-debug plugin:uninstall BasecomFixturePlugin && \
	rm -rf /var/www/html/custom/plugins/FixturesPlugin && \
	sudo rm -rf /mollie && \
    sudo service mysql stop

ADD mollie_entrypoint.sh /mollie_entrypoint.sh

ENTRYPOINT ["/bin/bash", "/mollie_entrypoint.sh", "/entrypoint.sh"]
