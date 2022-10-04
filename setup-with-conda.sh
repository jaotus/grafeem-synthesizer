#!/usr/bin/env bash

set -e

DNN=$1

test -z "$1" &&  { echo "$LINENO: No container type: dnn or hmm" ; exit 1; }

if [ "$DNN" == "dnn" ] ; then
  container=dnn-grafeem
else
  container=hmm-grafeem
fi

buildah rm $container &>/dev/null || true

buildah from --name $container ubuntu:jammy-20220428



##### python

buildah run $container -- apt update
buildah run $container -- apt-get --yes install wget sox unzip git build-essential

buildah copy $container setup-conda.sh
buildah copy $container ossian.yml
buildah copy $container ossian-v.1.3.yml
buildah run  $container ./setup-conda.sh $DNN



##### Ossian

./download-tools.sh $DNN

buildah copy $container EKI-dnn.patch
buildah copy $container EKI-hmm-v.1.3.patch
buildah copy $container sptk.patch
buildah copy $container setup-ossian.sh

buildah run -v $(realpath ossian-download):/ossian-download $container ./setup-ossian.sh $DNN

# Add a small estonian corpus
buildah copy $container corpus /Ossian/corpus



##### cleanup

buildah run $container -- apt-get clean
buildah run $container -- apt autoremove
buildah run $container -- rm -rf '/var/lib/apt/lists/*' '/tmp/*' '/var/tmp/*'



##### Image config

buildah config --workingdir /Ossian $container
buildah config --volume /Ossian/voices $container
buildah config --volume /Ossian/corpus $container
buildah config --volume /Ossian/train $container
buildah config --volume /Ossian/test $container

buildah config --env LANG=C.utf8 $container
buildah config --env THEANO_FLAGS="" $container
buildah config --env USER=tester $container



##### Finalize image

echo "Create images"
buildah commit --squash $container $container-train-conda
echo "Created $container-train"
buildah run $container -- sh -c 'rm /Ossian/tools/bin/H* /Ossian/tools/bin/hts_engine'
buildah commit --squash --rm $container $container-conda
echo "Created $container"
podman image prune -f

