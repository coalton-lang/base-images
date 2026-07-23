FROM debian:13

LABEL org.opencontainers.image.source=https://github.com/coalton-lang/base-images
LABEL org.opencontainers.image.description="ECL base image for Coalton CI"
LABEL org.opencontainers.image.licenses=MIT

ARG USE_REPO=t

ARG ECL_MAJOR_VERSION=26
ARG ECL_MEDIUM_VERSION=5
ARG ECL_MINOR_VERSION=5
ARG ECL_VERSION=${ECL_MAJOR_VERSION}.${ECL_MEDIUM_VERSION}.${ECL_MINOR_VERSION}
# ARG ECL="ecl --norc -q"
ARG ECL="ecl -q"
ARG CC=gcc-14
ARG CXX=g++-14

# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  git \
  bzip2 \
  libgmp10 \
  libmpfr6 \
  \
  build-essential \
  libgmp-dev \
  libmpfr-dev \
  netbase \
  \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# Download and install ecl
RUN if [ "${USE_REPO}" != t ] ; then \
 echo Using release version ecl-${ECL_VERSION} \
 && ( curl -L -o ecl-binary.tgz \
      https://ecl.common-lisp.dev/static/files/release/ecl-${ECL_VERSION}.tgz \
    || curl --insecure -o ecl-binary.tgz \
      https://ecl.common-lisp.dev/static/files/release/ecl-${ECL_VERSION}.tgz \
    ) \
 && tar xzf ecl-binary.tgz \
 && gcc --version \
 && gcc-14 --version \
 && (cd ecl-${ECL_VERSION} && ./configure --prefix=/ && make && make install) \
 && rm -r ecl-binary.tgz ecl-${ECL_VERSION} \
 && ${ECL} --eval "(print 'success)" --shell /dev/null ; \
 fi

RUN if [ "${USE_REPO}" = t ] ; then \
 echo Using master branch of the ecl repository \
 && git clone -b master --single-branch \
        https://gitlab.com/embeddable-common-lisp/ecl.git \
 && cd ecl \
 && (make distclean || echo cannot distclean for some reason) \
 && ./configure \
 && make \
 && make install \
 && ${ECL} --eval "(print 'success)" --shell /dev/null ; \
 fi

# Download and install quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp \
 && ${ECL} --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" --shell /dev/null \
 && rm quicklisp.lisp && mkdir -p /root/ \
 && find / -name 'setup.lisp'

ENV ECL_HOME=/usr/local/lib/ecl-${ECL_VERSION}
COPY eclrc /.eclrc
COPY eclrc /root/.eclrc
RUN chmod 644 /.eclrc /root/.eclrc && ls -lrt /.eclrc /root/.eclrc

# workaround for old quicklisp and new FSET
WORKDIR /extras
RUN git clone https://github.com/melisgl/named-readtables.git
RUN git clone https://github.com/slburson/misc-extensions.git
RUN git clone https://github.com/slburson/fset.git
RUN git clone --single-branch --branch fix-define-test-package-for-abcl \
              https://github.com/appleby/fiasco.git fiasco

# fetch all needed QL libraries
ARG ALL_LIBS="trivial-garbage \
trivial-gray-streams \
autoload \
trivial-indent \
trivial-features \
closer-mop \
acclimation \
alexandria \
source-error \
mgl-pax-bootstrap \
documentation-utils \
concrete-syntax-tree \
float-features \
computable-reals \
eclector-concrete-syntax-tree \
eclector"

WORKDIR /

RUN \
    ( echo '(progn (format t "Loading libs~%")' \
     ; for f in ${ALL_LIBS} ; do \
         echo '  (cl:handler-case (ql:quickload :'$f') (cl:error (c) (declare (ignore c)) (format t "*** Failed to load ~A!!! ***~%" :'$f')))' \
     ; done \
     ; echo '(format t "Finished loading libs~%"))' \
    ) > /load-all-libs.lisp \
 && wc -l /load-all-libs.lisp \
 && ${ECL} --shell /load-all-libs.lisp \
 && rm -rf /root/.cache
# && ${ECL} --eval '#-quicklisp (load "/root/quicklisp/setup.lisp")' --shell /load-all-libs.lisp

WORKDIR /lisp

CMD ["ecl"]
