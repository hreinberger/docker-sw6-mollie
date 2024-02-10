FROM dockware/play:latest

RUN sudo service mysql start && \
    cd /var/www/html && composer config repositories.shopware-packages '{ "type": "composer", "url": "https://packages.shopware.com" }' && \
    cd /var/www/html && composer config bearer.packages.shopware.com "test" && \
    cd /var/www/html && composer require store.shopware.com/molliepayments && \
	cd /var/www/html && php bin/console --no-debug cache:clear && \
	cd /var/www/html && php bin/console --no-debug plugin:list && \
	cd /var/www/html && php bin/console --no-debug plugin:refresh && \
	cd /var/www/html && php bin/console --no-debug plugin:install --activate MolliePayments && \
    sudo service mysql stop

ADD mollie_entrypoint.sh /mollie_entrypoint.sh

ENTRYPOINT ["/bin/bash", "/mollie_entrypoint.sh", "/entrypoint.sh"]
