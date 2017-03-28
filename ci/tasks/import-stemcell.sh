#!/usr/bin/env bash

set -e

export bosh_softlayer_tool=$(realpath bosh-softlayer-tools/*)
chmod +x $bosh_softlayer_tool

export CANDIDATE_BUILD_NUMBER=$( cat version/number | sed 's/\.0$//;s/\.0$//' )

echo -e "\n Get stemcell vhd filename..."
stemcell_name="bosh-stemcell-$CANDIDATE_BUILD_NUMBER-$IAAS-esxi-$OS_NAME-$OS_VERSION-go_agent"
stemcell_vhd_filename="${stemcell_name}.vhd"

echo -e "\n Softlayer create from external source..."
IFS=':' read -ra OBJ_STORAGE_ACC_NAME <<< "$SWIFT_USERNAME"
URI="swift://${OBJ_STORAGE_ACC_NAME}@${SWIFT_CLUSTER}/${SWIFT_CONTAINER}/${stemcell_vhd_filename}"
$bosh_softlayer_tool -c import-image --os-ref-code UBUNTU_14_64 --uri ${URI} --public-name "light-bosh-stemcell-$CANDIDATE_BUILD_NUMBER-softlayer-xen-ubuntu-trusty-go_agent" \
    --public-note "Public_light_stemcell_${CANDIDATE_BUILD_NUMBER}" --public | tail -1 >> "${base_gopath}/../stemcell-image/stemcell-info.json"

