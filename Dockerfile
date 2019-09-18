FROM debian:stable
MAINTAINER Shinnosuke Sawada <6warashi9@gmail.com>

ENV HUGO_VERSION 0.58.2
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit
ENV HUB_VERSION 2.12.4
ENV HUB_TGZ hub-linux-amd64-${HUB_VERSION}
RUN apt-get update && apt-get install -y \
    python-pygments \
    git \
    rsync \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /tmp/
ADD https://github.com/github/hub/releases/download/v${HUB_VERSION}/${HUB_TGZ}.tgz /tmp/
RUN tar -xf /tmp/${HUGO_BINARY}.tar.gz -C /tmp/ hugo && mv /tmp/hugo /usr/local/bin/hugo && rm /tmp/${HUGO_BINARY}.tar.gz && tar -xf /tmp/${HUB_TGZ}.tgz -C /tmp/ ${HUB_TGZ}/bin/hub && mv /tmp/${HUB_TGZ}/bin/hub /usr/local/bin/hub && rm /tmp/${HUB_TGZ}.tgz && chmod +x /usr/local/bin/hugo && chmod +x /usr/local/bin/hub

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
