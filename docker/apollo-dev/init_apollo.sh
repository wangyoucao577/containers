#!/bin/bash -xe

APOLLO_ROOT_DIR="/apollo"

# https://github.com/ApolloAuto/apollo/blob/a36d6c5a88a02a2193a7de834413a649d606887a/docker/scripts/dev_start.sh#L57
DEFAULT_MAPS=(
    sunnyvale_big_loop
    sunnyvale_loop
    sunnyvale_with_two_offices
    san_mateo
)
VOLUME_VERSION="latest"

function prepare_maps() {
    for map_name in ${DEFAULT_MAPS[@]}; do
        map_image="ApolloAuto/apollo:map_volume-${map_name}-${VOLUME_VERSION}"
        docker pull ${map_image}
        #TODO: export mapdata 
        #docker run ${map_image}
    done
}

function clone_code() {

    if [ -d ${APOLLO_ROOT_DIR} ]; then
        rm -rf ${APOLLO_ROOT_DIR}
    fi

    git clone https://github.com/ApolloAuto/apollo.git ${APOLLO_ROOT_DIR}
}

function build_code_cpu() {
    cd ${APOLLO_ROOT_DIR}

    ./apollo.sh build_cpu
}

function main() {
    clone_code

    prepare_maps

    build_code_cpu
}

main "$@"
