FROM dockware/play:latest

RUN sudo service mysql start && \
    cd /var/www/html && composer config repositories.shopware-packages '{\"type\": \"composer\", \"url\": \"https://packages.shopware.com\"}' && \
    cd /var/www/html && composer require store.shopware.com/mollieshopware && \
	cd /var/www/html && php bin/console --no-debug cache:clear && \
	cd /var/www/html && php bin/console --no-debug plugin:list && \
	cd /var/www/html && php bin/console --no-debug plugin:install --activate MollieShopware && \
    sudo service mysql stop

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
