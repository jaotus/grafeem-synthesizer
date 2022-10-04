#!/usr/bin/env bash

LANGUAGE=et
SPEAKER=sml_tonu
test "$1" && LANGUAGE=$1
test "$2" && SPEAKER=$2

echo $LANGUAGE
echo $SPEAKER

export LANG=C.utf8
export USER=tester
rm -rf train/* voices/*

# conda activate ossian
. /venv/bin/activate

# training Ossian front end (aligning data and getting lexicon)
python ./scripts/train.py -l $LANGUAGE -s $SPEAKER -text Hamsuni_tekst naive || exit 1

mkdir -p test/{wav,txt}
echo "Sõida tasa üle silla." > ./test/txt/et.txt
python ./scripts/speak.py -l $LANGUAGE -s $SPEAKER -o ./test/wav/et.wav naive ./test/txt/et.txt

echo "Done! Try - aplay test/wav/et.wav"
