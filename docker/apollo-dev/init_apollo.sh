#!/bin/bash -xe

APOLLO_ROOT_DIR="/apollo"
APOLLO_MAP_DATA_PATH="${APOLLO_ROOT_DIR}/modules/map/data"

APOLLO_DOCKER_REPO="apolloauto/apollo"

# https://github.com/ApolloAuto/apollo/blob/a36d6c5a88a02a2193a7de834413a649d606887a/docker/scripts/dev_start.sh#L57
DEFAULT_MAPS=(
    sunnyvale_big_loop
    sunnyvale_loop
    sunnyvale_with_two_offices
    san_mateo
)
VOLUME_VERSION="latest"

function prepare_maps() {
    cd ${APOLLO_MAP_DATA_PATH}

    for map_name in ${DEFAULT_MAPS[@]}; do
        map_image="${APOLLO_DOCKER_REPO}:map_volume-${map_name}-${VOLUME_VERSION}"
        docker pull ${map_image}
        docker run --rm --mount "src=$(pwd),dst=/mapdata,type=bind" ${map_image} sh -c "cp -r ${APOLLO_MAP_DATA_PATH}/${map_name} /mapdata/ && chmod 777 /mapdata/${map_name}"
    done

    ls -lh 
    cd ${APOLLO_ROOT_DIR}
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
