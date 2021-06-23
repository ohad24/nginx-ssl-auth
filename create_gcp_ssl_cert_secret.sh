#!/bin/bash

kubectl create secret tls web-tls \
  --cert fullchain.pem --key privkey.pem
