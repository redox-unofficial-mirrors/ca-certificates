#!/usr/bin/env bash

set -ex

rm -rf build certs
mkdir -p build
cd build
curl \
    -o certdata.txt \
    --time-cond certdata.txt \
    https://hg.mozilla.org/releases/mozilla-release/raw-file/default/security/nss/lib/ckfw/builtins/certdata.txt
../make-ca.sh -D "${PWD}"
rsync -av --delete etc/ssl/certs/ ../certs/
