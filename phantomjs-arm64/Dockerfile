# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM arm64v8/debian:jessie-backports

ARG BUILDOP

ENV OPENSSL_FLAGS='no-idea no-mdc2 no-rc5 no-zlib enable-tlsext no-ssl2 no-ssl3 no-ssl3-method enable-rfc3779 enable-cms'

RUN echo "deb-src http://httpredir.debian.org/debian wheezy main" >> /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian stretch main" >> /etc/apt/sources.list && \
    echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list && \
    apt-key adv --recv-key --keyserver pgpkeys.mit.edu 6FB2A1C265FFB764 7638D0442B90D010 8B48AD6246925553 && \
    apt-get update     && \
    apt-get install -y    \
       build-essential git flex bison gperf python ruby git libfontconfig1-dev \
       dpkg-dev binutils gcc g++ libc-dev \
       libjpeg8-dev libpng12-dev \
       openssl=1.1.0e-2

RUN apt-get install -y wget libc6 libgcc1 libstdc++6 && \
    wget http://security.debian.org/debian-security/pool/updates/main/i/icu/libicu48_4.8.1.1-12+deb7u7_armhf.deb && \
    dpkg --add-architecture armhf && \
    apt-get update

RUN dpkg --force-all -i libicu48_4.8.1.1-12+deb7u7_armhf.deb

WORKDIR /tmp

RUN git clone git://github.com/ariya/phantomjs.git && \
    cd phantomjs           && \
    git checkout 2.1.1     && \
    git submodule init     && \
    git submodule update   && \
    apt-get source openssl && \
    apt-get source icu

RUN echo "Recompiling OpenSSL" && \
    cd phantomjs/openssl-1.0.1e && \
    ./Configure --prefix=/usr --openssldir=/etc/ssl --libdir=lib ${OPENSSL_FLAGS} debian-armhf

RUN cd phantomjs/openssl-1.0.1e && \
    rm Makefile && \
    wget -o Makefile https://gist.githubusercontent.com/rvagg/3ab9a1a7e16b576caef5/raw/8433b096539e3c01adc79fed0e5c8d05a1d66346/armv7-Makefile && \    
    make depend && make && make install

RUN echo "Building the static version of ICU library..." && \
    cd phantomjs/icu-4.8.1.1/source && \
    rm config.guess && \
    wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' && \
    ARCH=aarch64 ./configure --prefix=/usr --enable-static --disable-shared && \
    ARCH=aarch64 make && make install

RUN cd phantomjs/src/qt/qtbase && \
    ./configure -static -opensource -confirm-license -prefix /tmp/phantomjs/src/qt/qtbase -qt-zlib -qt-libpng -qt-libjpeg -qt-pcre -nomake examples -nomake tools -nomake tests -no-qml-debug -no-dbus -no-opengl -no-audio-backend -D QT_NO_GRAPHICSVIEW -D QT_NO_GRAPHICSEFFECT -D QT_NO_STYLESHEET -D QT_NO_STYLE_CDE -D QT_NO_STYLE_CLEANLOOKS -D QT_NO_STYLE_MOTIF -D QT_NO_STYLE_PLASTIQUE -D QT_NO_PRINTPREVIEWDIALOG -qpa phantom -openssl -openssl-linked -no-openvg -no-eglfs -no-egl -no-glib -no-gtkstyle -no-cups -no-sm -no-xinerama -no-xkb -no-xcb -no-kms -no-linuxfb -no-directfb -no-mtdev -no-libudev -no-evdev -no-pulseaudio -no-alsa -no-feature-PRINTPREVIEWWIDGET -fontconfig -icu -no-pkg-config -release

RUN echo "Compiling PhantomJS..." && \
    cd phantomjs && \
    python build.py ${BUILDOP} --confirm --release --qt-config="-no-pkg-config" --git-clean-qtbase --git-clean-qtwebkit

CMD ["/bin/bash"]
