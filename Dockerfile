FROM alpine:3.15.4 AS builder

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

ADD https://www.sqlite.org/2022/sqlite-autoconf-3380200.tar.gz sqlite-autoconf-3380200.tar.gz

RUN tar xvf sqlite-autoconf-3380200.tar.gz \
    && cd sqlite-autoconf-3380200 \
    && ./configure --enable-math --enable-fts --enable-json1 --enable-rtree \
    && make -j8 \
    && make install

RUN cd sqlite-autoconf-3380200 \
    && gcc -Os -I. -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_FTS4 \
    -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_JSON1 \
    -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS \
    -DHAVE_USLEEP -DHAVE_READLINE \
    shell.c sqlite3.c -ldl -lm -lreadline -lncurses -o /usr/local/bin/sqlite3

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

FROM alpine:3.15.4 AS image

RUN apk update && apk add --update --no-cache \
    expat \
    libxml2 \
    librttopo \
    minizip \
    proj \
    readline
   
COPY --from=sqlite /usr/local/lib /usr/local/lib
COPY --from=sqlite /usr/local/bin/sqlite3 /usr/local/bin/sqlite3
