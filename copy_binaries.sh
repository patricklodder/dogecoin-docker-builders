#!/bin/sh

IMAGE=$1

mkdir -p build

CONTAINER=`docker run -d ${IMAGE} /bin/sleep 120`
docker cp ${CONTAINER}:/build/src/dogecoind ./build/
docker cp ${CONTAINER}:/build/src/dogecoin-cli ./build/
docker cp ${CONTAINER}:/build/src/dogecoin-tx ./build/
docker cp ${CONTAINER}:/build/src/qt/dogecoin-qt ./build/

docker kill ${CONTAINER}
docker rm ${CONTAINER}
