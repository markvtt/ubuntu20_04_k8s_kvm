#!/bin/bash

curl -O https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz

tar -zxvf helm-v3.8.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

helm version
