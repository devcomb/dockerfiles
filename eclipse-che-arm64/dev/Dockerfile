# Copyright (c) 2012-2016 Codenvy, S.A., Red Hat, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#   Codenvy, S.A. - initial API and implementation
#   Mario Loriedo
#   James Drummond - ARM64 implementation
#
# build:
#   docker build -t  eclipse/debian_jdk8:aarch64 .
#
# use:
#   docker run -it --rm --name build-che
#              -v "$HOME/.m2:/home/user/.m2"
#              -v "$PWD":/home/user/che-build
#              -w /home/user/che-build
#              codenvy/che-dev:aarch64
#              mvn -DskipTests=true
#                  -Dfindbugs.skip=true
#                  -Dgwt.compiler.localWorkers=2 -T 1C
#                  -Dskip-validate-sources
#              clean install
#
# For Windows, replace $HOME with maven repo directory.
# For Windows, replace $PWD with Che source code directory.
#

FROM eclipse/debian_jdk8:aarch64
ENV NODE_VERSION=4.8.0 \
    NODE_PATH=/usr/local/lib/node_modules

RUN sudo apt-get update
    
RUN sudo apt-get -y install build-essential libffi-dev libssl-dev libkrb5-dev gcc make ruby-full rubygems
    
RUN sudo gem install sass compass && \
    sudo apt-get clean && \
    sudo apt-get -y autoremove && \
    sudo apt-get -y clean && \
    sudo rm -rf /var/lib/apt/lists/* && \
    set -ex \
    && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done && \
    cd /home/user && curl --insecure -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz" \
    && curl --insecure -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep "node-v$NODE_VERSION-linux-arm64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && sudo tar -xzf "node-v$NODE_VERSION-linux-arm64.tar.gz" -C /usr/local --strip-components=1 \
    && sudo rm "node-v$NODE_VERSION-linux-arm64.tar.gz" SHASUMS256.txt.asc \
    && sudo ln -s /usr/lib/libffi-*/include /usr/include/ffi

EXPOSE 3000 5000 9000
RUN sudo npm install -g npm@latest
RUN sudo npm install --unsafe-perm -g gulp bower typings

ENV GO_VERSION=1.6

RUN echo "deb http://http.us.debian.org/debian/ jessie-backports non-free contrib main" >> /etc/apt/sources.list && \
    sudo apt-get update && \
    curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.src.tar.gz" | tar xz -C /opt && \
    sudo apt-get install -y gccgo && \
    ls -l /usr/bin/go-6 && \
    sudo ln -s /usr/bin/go-6 /usr/bin/go && \
    cd /opt/go/src && \
    GOROOT_BOOTSTRAP=/usr ./make.bash

RUN sudo apt-get --purge remove -y gccgo && \
    sudo rm /usr/bin/go && \
    sudo apt-get autoremove

RUN echo "export PATH=/opt/go/bin:$PATH" >> ~/.bashrc && \
    sudo chown -R user:user /opt
WORKDIR /home/user
ENV PATH /opt/go/bin:$PATH
