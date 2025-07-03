FROM dockware/play:latest

ADD cert /usr/local/share/ca-certificates/extra

RUN sudo update-ca-certificates

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
