FROM node:10.16
MAINTAINER "Thomas Kugi <thomas.kugi@syon.at>"

ARG BUILD_DATE
ARG SOURCE_COMMIT
ARG DOCKERFILE_PATH
ARG SOURCE_TYPE

ENV DEBIAN_FRONTEND=noninteractive LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8 TERM=dumb DBUS_SESSION_BUS_ADDRESS=/dev/null \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    FIREFOX_VERSION=59.0.2 PHANTOMJS_VERSION=2.1.1 CHROME_VERSION=stable_current \
    SCREEN_WIDTH=1920 SCREEN_HEIGHT=1080 SCREEN_DEPTH=24

RUN rm -rf /var/lib/apt/lists/* && apt-get -q update &&\
  apt-get install -qy --force-yes xvfb fontconfig bzip2 curl \
    libxss1 libappindicator1 libindicator7 libpango1.0-0 fonts-liberation xdg-utils gconf-service \
    libasound2 libatk-bridge2.0-0 libatspi2.0-0 libgbm1 libgtk-3-0 libnspr4 libnss3 libxkbcommon0 \
  &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

# Xvfb provide an in-memory X-session for tests that require a GUI (from attlassian default image)
ENV DISPLAY=:99

RUN curl --silent --show-error --location --fail --retry 3 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 | tar xjfO - phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs > /usr/bin/phantomjs && chmod +x /usr/bin/phantomjs

RUN curl --silent --show-error --location --fail --retry 3 https://dl.google.com/linux/direct/google-chrome-${CHROME_VERSION}_amd64.deb > /tmp/google-chrome-${CHROME_VERSION}_amd64.deb && dpkg -i /tmp/google-chrome-${CHROME_VERSION}_amd64.deb && rm /tmp/google-chrome-${CHROME_VERSION}_amd64.deb

RUN curl --silent --show-error --location --fail --retry 3 http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 > /tmp/firefox-${FIREFOX_VERSION}.tar.bz2 && mkdir /opt/firefox-${FIREFOX_VERSION} && tar xjf /tmp/firefox-${FIREFOX_VERSION}.tar.bz2 -C /opt/firefox-${FIREFOX_VERSION} && rm /tmp/firefox-${FIREFOX_VERSION}.tar.bz2

RUN echo '#!/bin/bash' > /usr/bin/firefox &&\
    echo 'export $(dbus-launch) && set | grep -i dbus && exec xvfb-run -a -s "-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH} -ac +extension RANDR" /opt/firefox-${FIREFOX_VERSION}/firefox/firefox "$@"' >> /usr/bin/firefox &&\
    chmod +x /usr/bin/firefox

RUN mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome.orig &&\
    echo '#!/bin/bash' > /opt/google/chrome/google-chrome &&\
    echo 'exec xvfb-run -a -s "-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH} -ac +extension RANDR" /opt/google/chrome/google-chrome.orig --no-sandbox "$@"' >> /opt/google/chrome/google-chrome &&\
    chmod +x /opt/google/chrome/google-chrome

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="$DOCKERFILE_PATH/Dockerfile" \
      org.label-schema.license="GPLv2" \
      org.label-schema.name="Node 10.6 pipeline build image with web browsers for running functional tests. Firefox ${FIREFOX_VERSION}, Google Chrome ${CHROME_VERSION}, phantomjs ${PHANTOMJS_VERSION}. Default screen resolution ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}. Install essentials for protractor testing with angular" \
      org.label-schema.url="https://github.com/syon-development/bitbucket-pipeline-angular-node-protractor" \
      org.label-schema.vcs-ref=$SOURCE_COMMIT \
      org.label-schema.vcs-type="$SOURCE_TYPE" \
      org.label-schema.vcs-url="https://github.com/syon-development/bitbucket-pipeline-angular-node-protractor.git"


RUN npm install -g protractor jasmine jasmine-spec-reporter @angular/cli @nrwl/cli && webdriver-manager update
