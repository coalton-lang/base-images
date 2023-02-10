FROM debian:11

LABEL org.opencontainers.image.source=https://github.com/coalton-lang/base-images
LABEL org.opencontainers.image.description="CCL base image for Coalton CI"
LABEL org.opencontainers.image.licenses=MIT

ARG CCL_VERSION=1.12.1

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Download and install ccl
RUN curl -L -o ccl-binary.tar.gz https://github.com/Clozure/ccl/releases/download/v${CCL_VERSION}/ccl-${CCL_VERSION}-linuxx86.tar.gz \
  && tar xf ccl-binary.tar.gz -C /usr/local/src \
  && rm ccl-binary.tar.gz 

ENV PATH=/usr/local/src/ccl/scripts:${PATH}

# Download and install quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp  \
  && ccl64 --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" \
  && rm quicklisp.lisp

COPY ccl-init.lisp /root
COPY ccl64-wrapped.sh /usr/local/src/ccl/scripts

WORKDIR /lisp
CMD ["ccl64-wrapped.sh"]
