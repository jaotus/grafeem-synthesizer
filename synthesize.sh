#!/usr/bin/env bash

LANGUAGE=et
SPEAKER=sml_tonu
test "$1" && LANGUAGE=$1
test "$2" && SPEAKER=$2

echo $LANGUAGE
echo $SPEAKER

export LANG=C.utf8
export THEANO_FLAGS=""
export USER=tester

# conda activate ossian
. /venv/bin/activate

mkdir -p test/{wav,txt}
echo "Sõida tasa üle silla." > ./test/txt/et.txt
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o ./test/wav/et_nn.wav naive_02_nn ./test/txt/et.txt

echo "Done! Try - aplay test/wav/et_nn.wav"
