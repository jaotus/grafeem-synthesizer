#!/usr/bin/env bash

# Run a small test

set -e
[[ -n "$1" ]] && conda=-$1

mkdir -p corpus train voices test

# for external corpora add:
#    -v $(realpath corpus):/Ossian/corpus \

podman -v &>/dev/null && rt=podman || rt=docker
exec $rt run --rm -i \
	-v $(realpath train):/Ossian/train \
	-v $(realpath voices):/Ossian/voices \
	-v $(realpath test):/Ossian/test \
   ghcr.io/jaotus/hmm-grafeem-train$conda:latest bash <./train-hmm.sh
