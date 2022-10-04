#!/usr/bin/env bash

set -e

LANGUAGE=et
SPEAKER=sml_tonu
test "$1" && LANGUAGE=$1
test "$2" && SPEAKER=$2

echo $LANGUAGE
echo $SPEAKER

corpus_map="-v $(realpath corpus):/Ossian/corpus"
[ "$LANGUAGE" == "et" ] && [ "$SPEAKER" == "sml_tonu" ]  &&  corpus_map=""
echo Using: $corpus_map

mkdir -p corpus train voices test

podman -v &>/dev/null && rt=podman || rt=docker

exec $rt run --rm -i $corpus_map \
   -v $(realpath train):/Ossian/train \
   -v $(realpath voices):/Ossian/voices \
   -v $(realpath test):/Ossian/test \
   ghcr.io/jaotus/hmm-grafeem-train:latest bash <<EOF
export LANG=C.utf8
export USER=tester

rm -rf train/$LANGUAGE/speakers/$SPEAKER voices/$LANGUAGE/$SPEAKER

# conda activate ossian
. /venv/bin/activate

# training Ossian front end (aligning data and getting lexicon)
python ./scripts/train.py -l $LANGUAGE -s $SPEAKER -text Hamsuni_tekst naive || exit 1

mkdir -p test/{wav,txt}
echo "Sõida tasa üle silla oskab igaüks öelda, aga proovige öelda adsorbtsioonispekter." > ./test/txt/${SPEAKER}.txt
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o ./test/wav/${SPEAKER}.wav naive ./test/txt/${SPEAKER}.txt

echo "Done! Try - aplay test/wav/${SPEAKER}.wav"
EOF