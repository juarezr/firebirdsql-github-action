#!/bin/sh

export INPUT_FIREBIRD_DATABASE="my_database.fdb"

export INPUT_FIREBIRD_USER="my_user"

export INPUT_FIREBIRD_PASSWORD="my_password"

for target in latest v4.0 v3.0 2.5-ss 2.5-sc; do
    export INPUT_VERSION="${target}"
    echo "# Creating the docker container for FirebirdSQL version: ${INPUT_VERSION}"
    ./entrypoint.sh

    echo '# Querying the docker database...'
    echo 'select * from rdb$database;' \
        | isql-fb -bail -quiet -z -user my_user -password my_password 'localhost:/firebird/data/my_database.fdb' \
        && echo "SUCCESS: ${INPUT_VERSION}" \
        || echo "FAILURE: ${INPUT_VERSION}"

    echo '# Removing the docker container...'
    docker rm --volumes --force firebirdsql
done

echo '# Finished!'
