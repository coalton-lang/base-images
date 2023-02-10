#!/usr/bin/env bash
set -eou pipefail

exec /usr/local/src/ccl/scripts/ccl64 --no-init --load /root/ccl-init.lisp $@
