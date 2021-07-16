#!/bin/bash

# docker run --rm -it -v ${PWD}/certs:/certs alpine sh
# cd /certs
# apk update
# apk add openssh
# sh generate.sh

openssl genrsa 2048 > selfsigned.key
openssl req -new -key selfsigned.key -out selfsigned.csr -subj "/CN=test.com"
openssl x509 -req -days 3650 -in selfsigned.csr -signkey selfsigned.key -out selfsigned.crt
