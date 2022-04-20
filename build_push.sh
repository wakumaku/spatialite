#!/usr/bin/env bash
set -Eeuo pipefail

docker build . -t spatialite:build

docker image tag spatialite:build wakumaku/spatialite:latest

docker image push wakumaku/spatialite:latest