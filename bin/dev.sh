#!/bin/bash
docker image build \
  --file Dockerfile-dev \
  --tag front-test \
  . \

docker container run --rm -it -p 8080:3000 front-test
