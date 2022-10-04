#!/usr/bin/env bash

set -e

DNN=$1

mkdir -p ossian-download
cd ossian-download

# Ossian
if [ "$DNN" == "dnn" ] ; then
  test ! -f master.zip && \
    wget https://github.com/CSTR-Edinburgh/Ossian/archive/refs/heads/master.zip
fi

# Tools
HTK_USERNAME="YOUR REGISTERED NAME"
HTK_PASSWORD="YOUR PASSWORD"

test ! -f HTK-3.4.1.tar.gz && \
    wget http://htk.eng.cam.ac.uk/ftp/software/HTK-3.4.1.tar.gz --http-user=$HTK_USERNAME --http-password=$HTK_PASSWORD
test ! -f HDecode-3.4.1.tar.gz  && \
    wget http://htk.eng.cam.ac.uk/ftp/software/hdecode/HDecode-3.4.1.tar.gz  --http-user=$HTK_USERNAME --http-password=$HTK_PASSWORD
test ! -f HTS-2.3alpha_for_HTK-3.4.1.tar.bz2 && \
    wget http://hts.sp.nitech.ac.jp/archives/2.3alpha/HTS-2.3alpha_for_HTK-3.4.1.tar.bz2
test ! -f hts_engine_API-1.05.tar.gz && 
    wget http://sourceforge.net/projects/hts-engine/files/hts_engine%20API/hts_engine_API-1.05/hts_engine_API-1.05.tar.gz
test ! -f SPTK-3.6.tar.gz && \
    wget http://downloads.sourceforge.net/sp-tk/SPTK-3.6.tar.gz

cd ..
