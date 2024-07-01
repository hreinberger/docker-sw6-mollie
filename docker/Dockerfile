FROM dockware/play:latest

ADD scripts /scripts
ADD mollie_logs.json /var/www/pimpmylog/config.user.d/mollie_logs.json
ADD mollie_entrypoint.sh /mollie_entrypoint.sh

RUN sudo service mysql start && \
    sudo chown 33:33 /scripts -R && sudo chmod 775 /scripts -R && \
    sudo chown 33:33 /mollie -R && sudo chmod 775 /mollie -R && \
    # --------------------------------------------------------------------------------
    cd /scripts && sh prepare-store.sh && \
    cd /scripts && sh install-plugins.sh && \
    cd /scripts && sh run-fixtures.sh && \
    # --------------------------------------------------------------------------------
	cd /scripts && sh post-clean.sh && \
    sudo service mysql stop

ENTRYPOINT ["/bin/bash", "/mollie_entrypoint.sh", "/entrypoint.sh"]
