# Build scripts for Docker images of the _dnn/hmm_ grapheme based speech synthesizers

Create docker images for an Ossian based speech synthesizer.

## Build images
`setup.sh` is building two images for each (dnn/hmm):
- full Ossian synthesizer with training support for the new voices
- synthesizer only

To build DNN images without licence restrictions use:
```bash
./setup.sh dnn
```
and
```bash
./setup.sh hmm
```
To build commercially restricted __conda__ versions use:
```bash
./setup-with-conda.sh dnn
```
and
```bash
./setup-with-conda.sh hmm
```

The build scripts assume that you have
- Ossian registration credentials (if needed) in `setup-ossian.sh` (see [Ossian demo](http://jrmeyer.github.io/tts/2017/09/15/Ossian-Merlin-demo.html))
- Installed podman and buildah: 'sudo apt-get install podman buildah'
- if needed add for your user:
  - in `/etc/subuid`
     ``` 
     yourusername:100000:65536
     ```
  - in `/etc/subgid`
    ``` 
    yourusername:100000:65536
    ```
  Replace `yourusername` whit your linux username.  

## Train a tiny voice

`test-train.sh` will use the image __dnn-

eem-train__ to train a sample voice.
`test-train-hmm.sh` will use the image __hmm-grafeem-train__ to train a sample voice.

Conda versions can be tested by adding `conda` parameter:
```bash
./test-train.sh conda
```

Also the image __dnn-grafeem-train__ is available at
`ghcr.io/jaotus/dnn-grafeem-train:latest` and can be tested with `test-synthesize-cloud.sh`.



## Customization

Synthesizer parameters can be customized by modifying the files
- train.sh
- train-hmm.sh
- synthesize.sh
- synthesize-hmm.sh

Container images allow mapping of the following folders:
- /Ossian/voices
- /Ossian/corpus
- /Ossian/train
- /Ossian/test

Also some Ossian parameters can be specified for these scripts:
```bash
LANGUAGE=et
SPEAKER=sml_tonu
```

## Windows and __Docker Desktop__
These containers can also be run on Windows10/11 systems.
For this 
- install Docker desktop (see [Windows installation](https://docs.docker.com/desktop/install/windows-install/]))
- when asked select __WSL 2 backend__ and __Ubuntu Linux__ (default)

Now you can start __Ubuntu__ and verify that command `docker` prints the help message.

### Training

The test-* scripts work with __docker__ and __podman__ also.


