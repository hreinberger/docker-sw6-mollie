# Dockware, Cloudflare Tunnel and Mitmproxy

Mollie doesn’t offer a real API log, so sometimes it’s beneficial to intercept API communication between Shop and Mollie API to get a view on what really happens. That’s where mitmproxy comes in.

I’m keeping my demo shops dockerized, so I needed a solution that can intercept API requests from a docker container and transparently forward them to Mollie. HTTPS makes this hard, because we need a Certificate Authority that’s trusted by the shop container.

## tl;dr: First Start

Assuming you're on a mac:

1. clone the repo to a local folder
2. `cp .env.example .env` and add shop URL and Cloudflare tunnel token
3. `docker compose up -d mitmproxy` to start mitmproxy and let it generate the certs.
4. `openssl x509 -in ~/docker/mitmproxy/.mitmproxy/mitmproxy-ca.pem -inform PEM -out <repo_folder>/docker/cert/mitmproxy-ca.crt` and `openssl x509 -in ~/docker/mitmproxy/.mitmproxy/mitmproxy-ca-cert.pem -inform PEM -out <repo_folder>/docker/cert/mitmproxy-ca-cert.crt` to copy the certs to the docker build context
5. `docker compose build` to build the image that holds mitmproxy's certs
6. `docker compose up -d`
7. tadaa 🎉

Now you can access your shop with the domain you set in Cloudflare and can access mitmproxy at `http://localhost:9001` - the password is set to `mitm`. Enjoy!

## Components and Concepts

### Dockware

The main shop is set up using Dockware Play

```yaml
shop:
    container_name: shopware
    restart: unless-stopped
    extra_hosts:
        - 'api.mollie.com:10.5.0.5'
    build:
        context: ./docker
        dockerfile: Dockerfile
    environment:
        - TZ=Europe/Berlin
        - SHOP_DOMAIN=${SHOP_DOMAIN}
    volumes:
        - 'db_volume:/var/lib/mysql'
        - 'shop_volume:/var/www/html'
        - ./logs:/var/www/html/var/log
    networks:
        shopware_net:
```

I'm bind-mounting the logs folder for easy access. We're also setting a fixed IP for `api.mollie.com` so that it's not resolved from DNS.

### Cloudflare Tunnel

I'm using Cloudflare tunnels for exposing the shop to the web.

```yaml
tunnel:
    container_name: tunnel
    restart: unless-stopped
    image: cloudflare/cloudflared:latest
    command: tunnel run
    environment:
        - TUNNEL_TOKEN=${TUNNEL_TOKEN}
        - TZ=Europe/Berlin
    networks:
        shopware_net:
```

The tunnel is set up in Cloudflare ZeroTrust and needs a `TUNNEL_TOKEN` in the `.env` file to work. The tunnel service connects to my Cloudflare account and sets the shop up for external availability. This way, the shop is available from the web with webhooks to the shop working out of the box.

### MITM Proxy

Thankfully, mitmproxy, the gold standard for these kinds of use cases, has a docker image ready: https://hub.docker.com/r/mitmproxy/mitmproxy/

So in my compose.yml, I can add the service like this:

```yaml
mitmproxy:
    container_name: mitmproxy
    stdin_open: true
    tty: true
    ports:
        - 9000:8080
        - 0.0.0.0:9001:8081
    image: mitmproxy/mitmproxy
    volumes:
        - ~/docker/mitmproxy/.mitmproxy:/home/mitmproxy/.mitmproxy
    command: mitmweb --web-host 0.0.0.0 --mode reverse:https://api.mollie.com@443 --set web_password=mitm
    networks:
        shopware_net:
            ipv4_address: 10.5.0.5
```

This starts the container, runs the mitmweb web interface at port 9001 (with the password `mitm`) and starts a reverse proxy that listens on Port 443 (the HTTPS port) and forwards everything to api.mollie.com. We also assign a fixed IP to the container that matches the IP we set for `api.mollie.com` earlier.

### Certificates

One last problem: The shop container needs to trust our Proxy! This can be handled by adding the proxy root CA to the shop container’s store of trusted certificates.

That's why we mount the cert directory to our home directory. On first run, mitmproxy will create the root CA and dump it there. Then we can convert it to a .crt file:

```
openssl x509 -in foo.pem -inform PEM -out foo.crt
```

So now, we can add the certs to a folder in docker’s build context in this repo.
