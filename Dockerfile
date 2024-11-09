FROM alpine:3.18.9 AS builder

RUN apk update && apk add --update --no-cache \
    fossil \
    build-base \
    readline-dev \
    minizip-dev \
    libxml2-dev \
    librttopo-dev \
    proj-dev \
    expat-dev \
    geos-dev \
    zlib-dev

FROM builder AS sqlite

WORKDIR /src

ENV VERSION=3430100

ADD https://www.sqlite.org/2023/sqlite-autoconf-${VERSION}.tar.gz sqlite-autoconf-${VERSION}.tar.gz

RUN tar xvf sqlite-autoconf-${VERSION}.tar.gz \
    && cd sqlite-autoconf-${VERSION} \
    && ./configure --enable-math --enable-fts --enable-json1 --enable-rtree \
    && make -j8 \
    && make install-strip

RUN fossil clone https://www.gaia-gis.it/fossil/freexl freexl.fossil --user anonymous \
    && mkdir freexl && cd freexl \
    && fossil open ../freexl.fossil \
    && ./configure \
    && make -j8 \
    && make install

RUN fossil clone https://www.gaia-gis.it/fossil/libspatialite libspatialite.fossil --user anonymous \
    && mkdir libspatialite && cd libspatialite \
    && fossil open ../libspatialite.fossil \
    && ./configure \
    && make -j8 \
    && make install

FROM alpine:3.18.9 AS image

RUN apk update && apk add --update --no-cache \
    expat \
    libxml2 \
    librttopo \
    minizip \
    proj \
    readline
   
COPY --from=sqlite /usr/local/lib /usr/local/lib
COPY --from=sqlite /usr/local/bin/sqlite3 /usr/local/bin/sqlite3
