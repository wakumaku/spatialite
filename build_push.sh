#!/usr/bin/env bash
set -Eeuo pipefail

VERSION=3.42.0-2022-09-09

docker build . -t spatialite:build

docker run -t --rm \
    -v $(pwd)/test.sh:/test.sh \
    -v $(pwd)/test.sql:/test.sql \
    -v $(pwd)/test_expected_output.txt:/test_expected_output.txt \
    spatialite:build sh -c '/test.sh'

echo "Tagging images ..."
docker image tag spatialite:build wakumaku/spatialite:latest
docker image tag spatialite:build wakumaku/spatialite:${VERSION}

echo "Pusing images ..."
docker image push wakumaku/spatialite:latest
docker image push wakumaku/spatialite:${VERSION}
