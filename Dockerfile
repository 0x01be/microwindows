FROM alpine as build

RUN apk add --no-cache --virtual microwindows-build-dependencies \
    git \
    build-base \
    bison \
    flex-dev \
    libx11-dev \
    libpng-dev \
    freetype-dev \
    libxext-dev \
    libxinerama-dev \
    linux-headers

ENV MW_REVISION master
RUN git clone --depth 1 --branch ${MW_REVISION} https://github.com/ghaerr/microwindows.git /microwindows

WORKDIR /microwindows/src

RUN cp Configs/config.linux-X11 config

#FIXME: https://www.openwall.com/lists/musl/2017/02/20/3
RUN echo "#define PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP {{PTHREAD_MUTEX_RECURSIVE}}" | cat - /microwindows/src/nanox/client.c > /microwindows/src/nanox/client.c.new && mv /microwindows/src/nanox/client.c.new /microwindows/src/nanox/client.c

RUN make

