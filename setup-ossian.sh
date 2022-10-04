#!/usr/bin/env bash 

set -e

DNN=$1
echo "Variant:$DNN"

# Ossian Git checkout folder
OSSIAN=$(realpath Ossian)
DOWNLOADS=$(realpath ossian-download)

pushd .

## Ossian from Github

rm -rf $OSSIAN

if [ $DNN == "dnn" ] ; then
	unzip $DOWNLOADS/master.zip
	mv Ossian-master Ossian
	cd $OSSIAN
	patch -p1 -d . < ../EKI-dnn.patch
else
	tar --no-same-owner -xf $DOWNLOADS/ossian-v.1.3.tgz
	mv ossian-v.1.3 Ossian
	cd $OSSIAN
	patch -p1 -d . < ../EKI-hmm-v.1.3.patch
fi

# Make sure these locations exist:
mkdir -p $OSSIAN/tools/bin
mkdir -p $OSSIAN/tools/downloads

## MERLIN

if [ "$DNN" == "dnn" ] ; then
    cd $OSSIAN/tools/
    #fixme replace with local copy
    git clone https://github.com/CSTR-Edinburgh/merlin.git
    cd merlin
    ## reset to this specific version, which I have tested, must check later versions:--
    git reset --hard 8aed278  

    ## Ossian will use Merlin's copy of World, instead of its own as previously:-
    cd tools/WORLD/
    make -f makefile
    make -f makefile analysis
    make -f makefile synth

    cp build/{analysis,synth} $OSSIAN/tools/bin/
fi

## HTK

    cd $OSSIAN/tools/downloads
    tar --no-same-owner -zxvf $DOWNLOADS/HTK-3.4.1.tar.gz
    tar --no-same-owner -zxvf $DOWNLOADS/HDecode-3.4.1.tar.gz
    tar --no-same-owner -xvf $DOWNLOADS/HTS-2.3alpha_for_HTK-3.4.1.tar.bz2

    ## Apply HTS patch:
    cd htk
    patch -p1 -d . < ../HTS-2.3alpha_for_HTK-3.4.1.patch

    ## Apply the Ossian/tools/patch:
    patch -p1 -d . < ../../patch/ossian_hts.patch

    ## Finally, configure and compile:
    ./configure --prefix=$OSSIAN/tools/ --without-x --disable-hslab
    make
    make install

## HTS

    cd $OSSIAN/tools/downloads
    tar --no-same-owner -xvf $DOWNLOADS/hts_engine_API-1.05.tar.gz
    cd hts_engine_API-1.05
    ## Patch engine for use with Ossian (glottHMM compatibility):
    patch -p1 -d . < ../../patch/ossian_engine.patch
    ./configure --prefix=$OSSIAN/tools/
    make
    make install

## SPTK

    cd $OSSIAN/tools/downloads
    tar --no-same-owner -xvf $DOWNLOADS/SPTK-3.6.tar.gz
    cd SPTK-3.6
    ./configure --prefix=$OSSIAN/tools/

    patch -p1 -d . < $DOWNLOADS/../sptk.patch
    
    make
    make install

    ## Count the binaries in your bin directory:
    ls $OSSIAN/tools/bin/* | wc -l
    ## If all the tools have been compiled OK, you should have 160 or 163 of them.

## GlottHMM
# Unused
#	cd $OSSIAN/tools/GlottHMM/
#	make

popd

echo -e "\nDone - Ossian\n"
