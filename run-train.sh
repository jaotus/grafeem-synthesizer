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
   ghcr.io/jaotus/dnn-grafeem-train:latest bash <<EOF

export LANG=C.utf8
export THEANO_FLAGS=""
export USER=tester
rm -rf train/$LANGUAGE/speakers/$SPEAKER voices/$LANGUAGE/$SPEAKER

# conda activate ossian
. /venv/bin/activate

# training Ossian front end (aligning data and getting lexicon)
python ./scripts/train.py -s $SPEAKER -l $LANGUAGE naive_02_nn || exit 1


# training Merlin's duration model
python ./tools/merlin/src/run_merlin.py \
        train/$LANGUAGE/speakers/$SPEAKER/naive_02_nn/processors/duration_predictor/config.cfg \
        || exit 1

# converting Merlin's duration model to Ossian's format
python ./scripts/util/store_merlin_model.py \
        train/$LANGUAGE/speakers/$SPEAKER/naive_02_nn/processors/duration_predictor/config.cfg \
        voices/$LANGUAGE/$SPEAKER/naive_02_nn/processors/duration_predictor || exit 1


# training Merlin's acoustic model
python ./tools/merlin/src/run_merlin.py \
        train/$LANGUAGE/speakers/$SPEAKER/naive_02_nn/processors/acoustic_predictor/config.cfg \
        || exit 1

# converting Merlin's acoustic model to Ossian's format
python ./scripts/util/store_merlin_model.py \
        train/$LANGUAGE/speakers/$SPEAKER/naive_02_nn/processors/acoustic_predictor/config.cfg \
        voices/$LANGUAGE/$SPEAKER/naive_02_nn/processors/acoustic_predictor || exit 1

ls -d train/$LANGUAGE/speakers/$SPEAKER/naive_02_nn/*/ | xargs rm -rf

mkdir -p test/{wav,txt}
echo "Sõida tasa üle silla oskab igaüks öelda, aga proovige öelda adsorbtsioonispekter." > ./test/txt/${SPEAKER}.txt
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o ./test/wav/${SPEAKER}.wav naive_02_nn ./test/txt/${SPEAKER}.txt

echo "Done! Try - aplay test/wav/_${SPEAKER}.wav"
EOF
