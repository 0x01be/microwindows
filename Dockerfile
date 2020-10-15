FROM alpine as build

RUN apk add --no-cache --virtual microwindows-build-dependencies \
    git \
    build-base \
    doxygen \
    graphviz \
    bison \
    linux-headers \
    flex-dev \
    libpng-dev \
    freetype-dev \
    libx11-dev \
    libxext-dev \
    libxinerama-dev

ENV MW_REVISION master
RUN git clone --depth 1 --branch ${MW_REVISION} https://github.com/ghaerr/microwindows.git /microwindows

WORKDIR /microwindows/src

RUN cp Configs/config.linux-X11 config

#FIXME: https://www.openwall.com/lists/musl/2017/02/20/3
RUN echo "#define PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP {{PTHREAD_MUTEX_RECURSIVE}}" | cat - /microwindows/src/nanox/client.c > /microwindows/src/nanox/client.c.new && mv /microwindows/src/nanox/client.c.new /microwindows/src/nanox/client.c

RUN make
RUN make doc

