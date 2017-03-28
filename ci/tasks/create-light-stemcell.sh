#!/usr/bin/env bash

set -e

export bosh_softlayer_tool=$(realpath bosh-softlayer-tools/*)
chmod +x $bosh_softlayer_tool

# outputs
output_dir="light-stemcell"
mkdir -p ${output_dir}

echo -e "\n Get stemcell version..."
stemcell_version=$(cat version/number | sed 's/\.0$//;s/\.0$//')

echo -e "\n Softlayer creating light stemcell..."
$bosh_softlayer_tool -c light-stemcell --version ${stemcell_version} --stemcell-info-filename "${base_gopath}/../stemcell-info/stemcell-info.json"

cp *.tgz "${base_gopath}/../${output_dir}/"

stemcell_filename=`ls light*.tgz`

checksum="$(sha1sum "${base_gopath}/../${output_dir}/${stemcell_filename}" | awk '{print $1}')"
echo "$stemcell_filename sha1=$checksum"

if [ -n "${BOSHIO_TOKEN}" ]; then
  curl -X POST \
      --fail \
      -d "sha1=${checksum}" \
      -H "Authorization: bearer ${BOSHIO_TOKEN}" \
      "https://bosh.io/checksums/${stemcell_filename}"
fi
