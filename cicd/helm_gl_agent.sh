#!/bin/bash

helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install gitlab-agent gitlab/gitlab-agent \
    --namespace gitlab-agent \
    --create-namespace \
    --set image.tag=v17.1.0-rc9 \
    --set config.token=glagent-Nj_Z5-PHacDHkJ5c7UvYKgwJh98zk7EKyyXqwuvxRC6bPxZPDA \
    --set config.kasAddress=wss://kas.gitlab.com