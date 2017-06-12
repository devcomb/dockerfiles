# Copyright (c) 2012-2016 Codenvy, S.A., Red Hat, Inc
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#   Mario Loriedo
#   Codenvy S.A
#   James Drummond - ARM64
#
# To build it, run in the repository root:
#  `docker build -t eclipse/che-server-arm64v8 .`
#
# To run it:
#  docker run -p 8080:8080 \
#             --name che \
#             --rm \
#             -v /var/run/docker.sock:/var/run/docker.sock \
#             -v /che-data:/data \
#             eclipse/che-server-arm64v8:latest
#           
FROM eclipse/che-base-arm64v8

ENV LANG=C.UTF-8 \
    DOCKER_VERSION=1.6.0 \
    DOCKER_BUCKET=get.docker.com \
    CHE_IN_CONTAINER=true

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update curl openssl sudo bash && \
#   This image requires volume mounting host docker cliect example-> `-v /usr/bin/docker:/usr/bin/docker`
#   curl -sSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}" -o /usr/bin/docker && \
#   chmod +x /usr/bin/docker && \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /tmp/* /var/cache/apk/*

ENV LD_LIBRARY_PATH=/usr/lib/jvm/default-jvm/jre/lib/aarch64/
EXPOSE 8000 8080
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ADD eclipse-che.tar.gz /home/user/
