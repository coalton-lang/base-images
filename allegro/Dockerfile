FROM debian:11

LABEL org.opencontainers.image.source=https://github.com/coalton-lang/base-images
LABEL org.opencontainers.image.description="Allegro CL base image for Coalton CI"
LABEL org.opencontainers.image.licenses=MIT

ARG ALLEGRO_VERSION=10.1

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  bzip2 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Download and install allegro
RUN curl -o allegro-binary.tar.bz2 https://franz.com/${ALLEGRO_VERSION}/dist/linuxamd64.64smp/acl${ALLEGRO_VERSION}-smp-linux-x64.tbz2 \
 && tar xf allegro-binary.tar.bz2 -C /usr/local \
 && rm allegro-binary.tar.bz2

ENV PATH=/usr/local/acl${ALLEGRO_VERSION}-smp.64:$PATH

# Install license
ARG ALLEGRO_LICENSE
RUN echo "${ALLEGRO_LICENSE}" > /usr/local/acl${ALLEGRO_VERSION}-smp.64/devel.lic

# Update allegro with patches
RUN update.sh -u

# Download and install quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp \
 && alisp -L quicklisp.lisp -e "(quicklisp-quickstart:install)"

COPY clinit.cl /root/.clinit.cl

WORKDIR /lisp
