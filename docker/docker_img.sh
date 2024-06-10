#!/bin/bash

set -e
git clone https://github.com/bosone87/test-app.git
cd test-app
docker build -t bosone/test-app:0.0.1 .
docker tag bosone/test-app:0.0.1 bosone/test-app:latest
docker login
docker push bosone/test-app:latest