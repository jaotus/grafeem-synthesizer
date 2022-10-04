#!/usr/bin/env bash

# Run a small synthesize test

set -e

test ! -e voices &&  { echo "No voice!"; exit 1; }

mkdir -p corpus train voices test

podman -v &>/dev/null && rt=podman || rt=docker
exec $rt run --rm -i \
   -v $(realpath voices):/Ossian/voices \
   -v $(realpath test):/Ossian/test \
   hmm-grafeem$conda:latest bash <./synthesize-hmm.sh
