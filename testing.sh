#!/bin/sh

export INPUT_FIREBIRD_DATABASE="my_database.fdb"

export INPUT_FIREBIRD_USER="my_user"

export INPUT_FIREBIRD_PASSWORD="my_password"

export INPUT_ISC_PASSWORD="masterkey"

export INPUT_PORT="3050"

export INPUT_VERSION="latest"

export INPUT_CONTAINER_NAME="firebirdsql"

echo '# Creating the docker database...'

./entrypoint.sh

echo '# Querying the docker database...'

echo 'select * from rdb$database;' | isql-fb -bail -quiet -z -user my_user -password my_password 'localhost:my_database.fdb' && echo 'SUCCESS' || echo "FAILURE"

echo '# Removing the docker container...'

docker rm --volumes --force firebirdsql

echo '# Finished!'
