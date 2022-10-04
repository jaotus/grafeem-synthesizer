# Using containerized synthesizers

## Data

Ossian based synthesizers are using specific folders for its input and output data:
- corpus
- train
- voices
- test

### Corpus
Ossian expects its input data for training to be in the directories:

```
corpus/<LANG>/speakers/<DATA_NAME>/txt/*.txt
corpus/<LANG>/speakers/<DATA_NAME>/wav/*.wav
```

Text and wave files should be numbered consistently with each other.
```<LANG>``` and ```<DATA_NAME>``` are both arbitrary strings,
but it is sensible to choose ones which make obvious sense.

[//]: # (TODO add examle)

### Train

Ossian will put all files generated during training on
the data ```<DATA_NAME>``` in language ```<LANG>``` according to recipe ```<RECIPE>``` in a directory called:
```
train/<LANG>/speakers/<DATA_NAME>/<RECIPE>/
```
Before rerunning the training you need to clean the data of the previous run:
```
rm -rf train/<LANG>/speakers/<DATA_NAME>/naive_02_nn voices/<LANG>/<DATA_NAME>/naive_02_nn
```

### Voices

The successfully trained voice components are copied to:

```
voices/<LANG>/<DATA_NAME>/<RECIPE>/
```

### Test

This folder is used for synthesis:
- `test/txt` contains sentences to be synthesized
- `test/wav` contains synthesized sentences

## Scripts
The scripts `run-train.sh` and `run-train-hmm.sh` are for training the DNN and HMM versions of Ossian models.
They take two parameters:
```bash
./run-train.sh <LANG> <DATA_NAME>
```
Default values are:
```bash
LANG=et
DATA_NAME=sml_tonu
```
When these parameters are not provided or match the defaults then the internal corpus is used for training.

Scripts for running only synthesis (using preexisting models)  are `run-synthesize.sh` and `run-synthesize-hmm.sh`.

