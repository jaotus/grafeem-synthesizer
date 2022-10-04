#!/usr/bin/env bash

set -e

LANGUAGE=et
SPEAKER=sml_tonu
test "$1" && LANGUAGE=$1
test "$2" && SPEAKER=$2

echo $LANGUAGE
echo $SPEAKER

test ! -e voices &&  { echo "No voice!"; exit 1; }

mkdir -p train test

podman -v &>/dev/null && rt=podman || rt=docker

exec $rt run --rm -i \
   -v $(realpath voices):/Ossian/voices \
   -v $(realpath test):/Ossian/test \
   ghcr.io/jaotus/hmm-grafeem-train:latest bash <<EOF
export LANG=C.utf8
export THEANO_FLAGS=""
export USER=tester

## conda activate ossian
. /venv/bin/activate

mkdir -p test/{wav,txt}
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o ./test/wav/${SPEAKER}.wav naive ./test/txt/*.txt
echo "Done! Try - aplay test/wav/${SPEAKER}.wav"
EOF
