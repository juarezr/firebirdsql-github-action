#!/bin/sh

#region Container Variables ------------------------------------------------------------

set -eu -o pipefail

echo '## Local testing of docker container versions ##'

export INPUT_CONTAINER_NAME='firebirdsql'
export INPUT_FIREBIRD_DATABASE='my_database.fdb'
export INPUT_FIREBIRD_USER='my_user'
export INPUT_FIREBIRD_PASSWORD='my_password'
export INPUT_FIREBIRD_CONF='ConnectionTimeout=180,DeadlockTimeout=10'
export INPUT_NETWORK_NAME='fbtest'

export FIREBIRD_DATA='/var/lib/firebird/data',

#endregion -----------------------------------------------------------------------------

#region Functions ----------------------------------------------------------------------

export MI=0; INPUT_VERSION='';

msg() { MI=$((MI+1)) ; >&2 printf '\e[93m#%s \e[94m#%d\e[0m %s\n' "${INPUT_VERSION}" "${MI}" "$*"; }

fail() { >&2 printf "\e[91m#%d\e[93m Failed\e[0m: %s ##\n" "${MI}" "$*"  && exit 99; }

hr(){ printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' - ; }

ident() { sed -e 's/^/  /' ; }

require() { if command -v "${1:-}" >/dev/null; then msg "Found: ${1:-}"; else fail "Missing cmd line app: ${1:-}"; fi; }

remove_it() { docker rm --volumes --force "${INPUT_CONTAINER_NAME}" > /dev/null 2> /dev/null || true ; }
remove_net() { docker network rm "${INPUT_NETWORK_NAME}" > /dev/null 2> /dev/null || true ; }

#endregion -----------------------------------------------------------------------------

#region Main ---------------------------------------------------------------------------

require 'docker'

remove_it; remove_net

docker network create "${INPUT_NETWORK_NAME}" 2> /dev/null || true;

for INPUT_VERSION in latest 5 5.0.2 5-noble 5-jammy 4 4.0.5 3 3.0.12; do
    MI=0; hr;
    export INPUT_VERSION;
    msg "Testing the docker container for FirebirdSQL server version: ${INPUT_VERSION}:"
    if ! ./entrypoint.sh | ident; then
        remove_it; remove_net
        fail "error creating the container with version: ${INPUT_VERSION:-}";
    fi
    IP_ADDRESS="$( docker container inspect -f '{{.NetworkSettings.IPAddress}}' "${INPUT_CONTAINER_NAME}" )"
    if [ -z "${IP_ADDRESS:-}" ]; then
        IP_ADDRESS="$( docker container inspect -f "{{.NetworkSettings.Networks.${INPUT_NETWORK_NAME}.IPAddress}}" "${INPUT_CONTAINER_NAME}" )"
    fi
    if [ -z "${IP_ADDRESS:-}" ]; then
        remove_it; remove_net
        fail "unable to find the IP address of container version ${INPUT_VERSION:-} in the network ${INPUT_NETWORK_NAME:-}";
    fi
    msg "Querying the FirebirdSQL server inside the docker container at [${IP_ADDRESS}]..."

    if ! echo 'SELECT * FROM rdb$database;' |
        docker run -i --rm --name "${INPUT_CONTAINER_NAME}-client2" \
            --network "${INPUT_NETWORK_NAME}" --env IP_ADDRESS="${IP_ADDRESS}" \
            "firebirdsql/firebird:${INPUT_VERSION:-}" \
            sh -c isql -bail -quiet -echo -merge -m2 -z \
            -user "${INPUT_FIREBIRD_USER}" -password "${INPUT_FIREBIRD_PASSWORD}" \
            "${IP_ADDRESS}:${FIREBIRD_DATA}/${INPUT_FIREBIRD_DATABASE}" | ident; 
        then
            hr; remove_it; remove_net
            fail "error connecting with version: ${INPUT_VERSION:-}";
        fi

    msg "Removing the FirebirdSQL server docker container...\n\n"
    remove_it
done

hr; remove_net

msg '# Successfully Finished ##'
exit 0

#endregion -----------------------------------------------------------------------------
