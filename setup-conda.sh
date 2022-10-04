#!/usr/bin/env bash

# Create a virtual python environment for Ossian
set -e
DNN=$1

if test ! -f Miniconda3-latest-Linux-x86_64.sh ; then
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  chmod +x Miniconda3-latest-Linux-x86_64.sh
  ./Miniconda3-latest-Linux-x86_64.sh -b
  /root/miniconda3/bin/conda init bash
fi

export PATH="/root/miniconda3/bin:$PATH"
eval "$(conda shell.bash hook)"

conda install -y -c conda-forge conda-pack
conda install -y -c conda-forge mamba


conda activate base
conda env remove -n ossian
rm -rf ossian.tar venv

if [ "$DNN" == "dnn" ]; then
  mamba env create -f ossian.yml
  #mamba env create -f ossian-forge.yml
else
  mamba env create -f ossian-v.1.3.yml
fi
conda activate base
conda-pack -n ossian -o ossian.tar
mkdir -p venv
tar xf ossian.tar -C venv
./venv/bin/conda-unpack


rm ossian.tar
rm -rf /root/miniconda3
