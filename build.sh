#!/bin/sh
DEPS_COMMIT=$(git log -n 1 --pretty=format:%h -- depends)
echo "Trying to get dependencies at $DEPS_COMMIT"

docker pull -q docker.pkg.github.com/patricklodder/dogecoin/deps:$DEPS_COMMIT

IMAGE=$(docker image ls -q \
               docker.pkg.github.com/patricklodder/dogecoin/deps:$DEPS_COMMIT)
if [ -z "$IMAGE" ]
then
  docker build -t docker.pkg.github.com/patricklodder/dogecoin/deps:$DEPS_COMMIT \
               --target=deps -f contrib/docker-build/Dockerfile.build .
else
  echo "Cached dependency image available."
fi

docker build \
  --cache-from=docker.pkg.github.com/patricklodder/dogecoin/deps:$DEPS_COMMIT \
  --target=build \
  -t build:latest \
  -f contrib/docker-build/Dockerfile.build \
  .

# run tests
docker build --cache-from=build:latest --target=test \
             -f contrib/docker-build/Dockerfile.build .
