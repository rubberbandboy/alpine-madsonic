FROM alpine:latest
MAINTAINER madsonic <support@madsonic.org>

ENV GID=991 UID=991
ENV JVM_MEMORY=256

# Madsonic Package Information
ENV PKG_NAME madsonic
ENV PKG_VER 7.0
ENV PKG_BUILD 10390
ENV PKG_DATE 20190510
ENV TGZ_NAME ${PKG_DATE}_${PKG_NAME}-${PKG_VER}.${PKG_BUILD}-standalone.tar.gz

WORKDIR /madsonic

RUN echo "@commlatest https://uk.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
 && apk -U add \
    ffmpeg \
    openjdk8-jre@commlatest \
    tini@commlatest \
 && wget -qO- http://madsonic.org/download/${PKG_VER}/${TGZ_NAME} | tar zxf - \
 && rm -f /var/cache/apk/*

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 4040
EXPOSE 4050

VOLUME /config /media /playlists /podcasts

LABEL description "Open source media streamer" \
      madsonic "Madsonic v${PKG_VER}"

CMD ["/sbin/tini","--","start.sh"]
