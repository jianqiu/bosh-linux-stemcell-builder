#!/usr/bin/env bash

set -e

CANDIDATE_BUILD_NUMBER=$( cat version/number | sed 's/\.0$//;s/\.0$//' )
CANDIDATE_BUILD_NUMBER=${CANDIDATE_BUILD_NUMBER}-hvm

echo "${CANDIDATE_BUILD_NUMBER}" > "hvm-version-info/hvm-version"