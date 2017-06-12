# Copyright (c) 2016 Codenvy, S.A.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# build:
#   docker build -t eclipse/che-base .
#
# use:
#    docker run eclipse/che-base

FROM arm64v8/alpine:3.5

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.11.2
ENV DOCKER_SHA256 8c2e0c35e3cda11706f54b2d46c2521a6e9026a7b13c7d4b8ae1f3a706fc55e1

# install packages
# coreutils is required for iso8601 compliant date utility
RUN mkdir -p /version \
    && mkdir -p /cli \
    && mkdir /scripts/ \
    && apk add --no-cache ca-certificates coreutils curl openssl jq \
    && apk add --update bash \
    && rm -rf /var/cache/apk/* \
    && set -x
# Use host's docker client 
# Minimum Docker version 1.12.6

RUN echo http://dl-4.alpinelinux.org/alpine/v3.5/community/ >> /etc/apk/repositories && \
    apk update && \
    apk add docker

COPY scripts/base /scripts/base/
COPY scripts/entrypoint.sh /scripts/entrypoint.sh

RUN chmod u+x /scripts/entrypoint.sh
