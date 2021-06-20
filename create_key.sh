#!/bin/bash

# ohad-kube.ddns.net
# https://linuxize.com/post/creating-a-self-signed-ssl-certificate/
# ohad-kube.ddns.net www.ohad-kube.ddns.net

# sudo add-apt-repository ppa:certbot/certbot
# sudo apt-add-repository -r ppa:certbot/certbot
# curl -o- https://raw.githubusercontent.com/vinyll/certbot-install/master/install.sh | bash

# sudo certbot certonly --manual -d ohad-kube.ddns.net -d www.ohad-kube.ddns.net


openssl req -newkey rsa:4096 \
    -x509 \
    -sha256 \
    -days 3650 \
    -nodes \
    -out ohad-kube.crt \
    -keyout ohad-kube.key