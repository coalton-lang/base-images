FROM debian:13

LABEL org.opencontainers.image.source=https://github.com/coalton-lang/base-images
LABEL org.opencontainers.image.description="ABCL base image for Coalton CI"
LABEL org.opencontainers.image.licenses=MIT

ARG ABCL_MAJOR_VERSION=1
ARG ABCL_MEDIUM_VERSION=9
ARG ABCL_MINOR_VERSION=2
ARG ABCL_VERSION=${ABCL_MAJOR_VERSION}.${ABCL_MEDIUM_VERSION}.${ABCL_MINOR_VERSION}
ARG ABCL_TAR=abcl-bin-${ABCL_VERSION}.tar.gz
# ARG ABCL="abcl --noinit --noinform --nosystem --batch"
ARG ABCL="abcl --noinform --batch"

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
  default-jdk ant \
  default-jre-headless \
  \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

### Download and install abcl
## The latest release 1.9.2 doesn't work with FSet - commented out.
# RUN curl -o ${ABCL_TAR} \
#     -fsSL https://abcl.org/releases/${ABCL_VERSION}/${ABCL_TAR} \
#  && tar xzf ${ABCL_TAR} \
#  && mv abcl-bin-${ABCL_VERSION}/abcl.jar /bin/ \
#  && echo '#! /bin/sh -' > /bin/abcl \
#  && echo 'exec java -cp /bin/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"' >> /bin/abcl \
#  && chmod 755 /bin/abcl \
#  && ${ABCL} --eval "(print 'success)" \
#  && rm -rf ${ABCL_TAR} abcl-bin-${ABCL_VERSION}/
##
## Using abcl from its repo instead.
RUN git clone https://github.com/armedbear/abcl.git \
  && cd abcl \
  && ant -f build.xml abcl.jar \
  && cp -p dist/abcl.jar /bin \
  && touch /bin/abcl \
  && chmod 755 /bin/abcl* \
  && ( \
     echo '#! /bin/sh -' ; \
     echo 'ABCL_JAR=/bin/abcl.jar	# Use your own path here.' ; \
     echo 'JAVA=$(which java)' ; \
     echo 'ABCL="${JAVA} -server -Xrs -cp ${ABCL_JAR} org.armedbear.lisp.Main"' ; \
     echo 'exec $ABCL "$@"' \
     ) >> /bin/abcl

# Download and install quicklisp
RUN set -x ; curl -O https://beta.quicklisp.org/quicklisp.lisp \
 && ${ABCL} --load quicklisp.lisp --eval "(quicklisp-quickstart:install)" \
 && rm quicklisp.lisp && mkdir -p /root/ \
 && find / -name 'setup.lisp'

COPY abclrc /.abclrc
COPY abclrc /root/.abclrc
RUN chmod 644 /.abclrc /root/.abclrc && ls -lrt /.abclrc /root/.abclrc

# workaround for old quicklisp and new FSet
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
 && ${ABCL} --load /load-all-libs.lisp \
 && rm -rf /root/.cache
# && ${ABCL} --eval '#-quicklisp (load "/root/quicklisp/setup.lisp")' --load /load-all-libs.lisp

WORKDIR /lisp
CMD ["abcl"]
