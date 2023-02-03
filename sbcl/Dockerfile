FROM debian:11

ARG SBCL_VERSION=2.3.0
ARG SBCL_ARCH=x86-64

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl \
  bzip2 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Download and install sbcl
RUN curl -o sbcl-binary.tar.bz2 https://netactuate.dl.sourceforge.net/project/sbcl/sbcl/${SBCL_VERSION}/sbcl-${SBCL_VERSION}-${SBCL_ARCH}-linux-binary.tar.bz2 \
 && tar xf sbcl-binary.tar.bz2 \
 && cd sbcl-${SBCL_VERSION}-${SBCL_ARCH}-linux \
 && ./install.sh \
 && cd .. \
 && rm -r sbcl-binary.tar.bz2 sbcl-${SBCL_VERSION}-${SBCL_ARCH}-linux

# Download and install quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp \
 && sbcl --load quicklisp.lisp --eval "(quicklisp-quickstart:install)"

COPY sbclrc /root/.sbclrc

WORKDIR /lisp
