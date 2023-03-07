FROM debian:11

LABEL org.opencontainers.image.source=https://github.com/coalton-lang/base-images
LABEL org.opencontainers.image.description="SBCL base image for Coalton CI"
LABEL org.opencontainers.image.licenses=MIT

ARG SBCL_VERSION=2.3.2
ARG SBCL_ARCH=x86-64

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  git \
  bzip2 \
  libgmp10 \
  libmpfr6 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Download and install sbcl
RUN curl -L -o sbcl-binary.tar.bz2 https://sourceforge.net/projects/sbcl/files/sbcl/${SBCL_VERSION}/sbcl-${SBCL_VERSION}-${SBCL_ARCH}-linux-binary.tar.bz2 \
 && tar xf sbcl-binary.tar.bz2 \
 && cd sbcl-${SBCL_VERSION}-${SBCL_ARCH}-linux \
 && ./install.sh \
 && cd .. \
 && rm -r sbcl-binary.tar.bz2 sbcl-${SBCL_VERSION}-${SBCL_ARCH}-linux

# Download and install quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp \
 && sbcl --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" \
 && rm quicklisp.lisp

ENV SBCL_HOME=/usr/local/lib/sbcl
COPY sbclrc ${SBCL_HOME}/sbclrc

WORKDIR /lisp
CMD ["sbcl"]
