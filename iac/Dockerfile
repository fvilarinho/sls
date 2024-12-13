# Compiling stage.
FROM alpine:3.21.0 as build

# Installs required packages to compile.
RUN apk update &&\
    apk upgrade && \
    apk add --no-cache linux-headers \
                       alpine-sdk \
                       cmake \
                       tcl \
                       openssl-dev \
                       zlib-dev

# Defines the workdir.
WORKDIR /tmp

# Clones the source code.
RUN git clone https://github.com/Edward-Wu/srt-live-server.git && \
    git clone https://github.com/Haivision/srt.git

WORKDIR /tmp/srt

# Compiles SRT libraries.
RUN ./configure && \
    make && \
    make install

# Compiles SLS libraries.
WORKDIR /tmp/srt-live-server

RUN echo "#include <ctime>" | cat - slscore/common.cpp > /tmp/out && \
    mv /tmp/out slscore/common.cpp

RUN make

# Build stage.
FROM alpine:3.21.0

# Default environment variables.
ENV LATENCY=200
ENV THREADS=2
ENV CONNECTIONS=300
ENV BACKLOG=100
ENV IDLE_TIMEOUT=60
ENV LISTEN_PORT=1935

ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib64
ENV HOME_DIR=/home/sls
ENV BIN_DIR=${HOME_DIR}/bin
ENV ETC_DIR=${HOME_DIR}/etc
ENV LOGS_DIR=${HOME_DIR}/logs

# Creates the filesystem structure.
RUN mkdir -p ${HOME_DIR} ${BIN_DIR} ${ETC_DIR} ${LOGS_DIR} && \
    adduser -D sls

# Copies the required files (libraries, configurations and startup script).
COPY etc/sls.conf.template ${ETC_DIR}
COPY bin/startup.sh ${BIN_DIR}
COPY --from=build /usr/local/bin/srt-* /usr/local/bin/
COPY --from=build /usr/local/lib/libsrt* /usr/local/lib/
COPY --from=build /tmp/srt-live-server/bin/* /usr/local/bin/

# Sets the filesystem permissions.
RUN chmod +x ${BIN_DIR}/*.sh && \
    chown -R sls:sls ${HOME_DIR} && \
    ln -s ${BIN_DIR}/startup.sh /entrypoint.sh

# Install required packages.
RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash \
                       openssl \
                       libstdc++

# Defines the default user.
USER sls

# Defines the work directory.
WORKDIR ${HOME_DIR}

# Defines the entrypoint (startup script).
ENTRYPOINT [ "/entrypoint.sh" ]