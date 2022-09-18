#!/bin/sh

set -eu

echo "## Local testing of docker container versions ##"

export INPUT_CONTAINER_NAME="firebirdsql"
export INPUT_FIREBIRD_DATABASE="my_database.fdb"
export INPUT_FIREBIRD_USER="my_user"
export INPUT_FIREBIRD_PASSWORD="my_password"

export msgi=0 ; function msg() { ((msgi++)) ; >&2 echo "#${msgi} ${msgs:-} $@" ; }
function fail() { >&2 echo "## #${msgi} Failed: $@ ##"  && exit 99 ; }
function ident() { cat - | while read line ; do echo "${1:-    }${line}" ; done ; }
function require() { which "${1:-}" &>/dev/null && msg "Found ${1:-}" || fail "Missing cmd line app: ${1:-}" ; }

function remove_it() { docker rm --volumes --force ${INPUT_CONTAINER_NAME} &> /dev/null || true ; }

require 'docker'

remove_it

for INPUT_VERSION in latest v4 v4.0 v3 v3.0 2.5-ss 2.5-sc; do
    msgs="${INPUT_VERSION}:" ; msg "Starting the docker container for FirebirdSQL server version: ${INPUT_VERSION}:"
    ./entrypoint.sh | ident
    msg "Checking if ${INPUT_CONTAINER_NAME} is ready..."
    for ii in $(seq 15 -2 1) ; do
        if  [[ "$( docker container inspect -f '{{.State.Running}}' ${INPUT_CONTAINER_NAME} )" == "true" ]] ; then break ; fi
        test ${ii} -le 1 && fail "Failed starting to ${INPUT_CONTAINER_NAME}!" 
        echo -n "."  ; sleep ${ii}
    done
    IP_ADDRESS="$( docker container inspect -f '{{.NetworkSettings.IPAddress}}' ${INPUT_CONTAINER_NAME} )"
    msg "Querying the FirebirdSQL server ${INPUT_VERSION} inside the docker container at ${IP_ADDRESS}..."
    echo 'select * from rdb$database;' |
        docker run -i --rm jacobalberty/firebird \
            /usr/local/firebird/bin/isql -bail -quiet -z \
            -user ${INPUT_FIREBIRD_USER} -password ${INPUT_FIREBIRD_PASSWORD} \
            "${IP_ADDRESS}:/firebird/data/my_database.fdb" | ident \
        || failure=1

    msg "Removing the FirebirdSQL ${INPUT_VERSION} server docker container..."
    remove_it
    test -z "${failure:-}" || fail "error connecting with version: ${INPUT_VERSION:-}"
done

msgs='' msg '# Successfully Finished ##'

exit 0

## end of script ##
