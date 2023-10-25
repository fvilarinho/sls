# Compiling stage
FROM alpine:latest as build

RUN apk update &&\
    apk upgrade && \
    apk add --no-cache linux-headers \
                       alpine-sdk \
                       cmake \
                       tcl \
                       openssl-dev \
                       zlib-dev

WORKDIR /tmp

RUN git clone https://github.com/Edward-Wu/srt-live-server.git && \
    git clone https://github.com/Haivision/srt.git

WORKDIR /tmp/srt

RUN ./configure && \
    make && \
    make install

WORKDIR /tmp/srt-live-server

RUN echo "#include <ctime>" | cat - slscore/common.cpp > /tmp/out && \
    mv /tmp/out slscore/common.cpp

RUN make

# Build stage
FROM alpine:latest

ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib64

RUN apk update && \
    apk upgrade && \
    apk add --no-cache openssl \
                       libstdc++

RUN adduser -D sls && \
    mkdir /etc/sls /logs && \
    chown sls /logs

COPY --from=build /usr/local/bin/srt-* /usr/local/bin/
COPY --from=build /usr/local/lib/libsrt* /usr/local/lib/
COPY --from=build /tmp/srt-live-server/bin/* /usr/local/bin/
COPY etc/sls.conf /etc/sls/

VOLUME /logs

EXPOSE 1935/udp

USER sls

WORKDIR /home/sls

ENTRYPOINT [ "sls", "-c", "/etc/sls/sls.conf" ]