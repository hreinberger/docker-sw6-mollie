FROM dockware/play:latest

# The tests folder is excluded at the moment
# so we have a local backup and copy the fixtures to the container
ADD tests /mollie/fixes/tests

ADD scripts /scripts
ADD mollie_logs.json /var/www/pimpmylog/config.user.d/mollie_logs.json
ADD mollie_entrypoint.sh /mollie_entrypoint.sh

RUN sudo service mysql start || true; && \
    sudo chown 33:33 /scripts -R && sudo chmod 775 /scripts -R && \
    sudo chown 33:33 /mollie -R && sudo chmod 775 /mollie -R && \
    # --------------------------------------------------------------------------------
    cd /scripts && sh prepare-store.sh && \
    cd /scripts && sh install-plugins.sh && \
    cd /scripts && sh run-fixtures.sh && \
    # -------------------------------------------------------------------------------- \
    # we set a custom webhook domain for the plugin, otherwise payments \
    # with localhost do not work ;)
    echo "MOLLIE_SHOP_DOMAIN=local.mollie.com" >> /var/www/html/.env && \
    # --------------------------------------------------------------------------------
	cd /scripts && sh post-clean.sh && \
    sudo service mysql stop || true

ENTRYPOINT ["/bin/bash", "/mollie_entrypoint.sh", "/entrypoint.sh"]
