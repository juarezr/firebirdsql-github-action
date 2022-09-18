#!/bin/sh

env_list=""

if [ -n "$INPUT_FIREBIRD_DATABASE" ]; then
    env_list="$env_list --env 'FIREBIRD_DATABASE=$INPUT_FIREBIRD_DATABASE'"
fi

if [ -n "$INPUT_FIREBIRD_USER" ]; then
    env_list="$env_list --env 'FIREBIRD_USER=$INPUT_FIREBIRD_USER'"
fi

if [ -n "$INPUT_FIREBIRD_PASSWORD" ]; then
    env_list="$env_list --env 'FIREBIRD_PASSWORD=$INPUT_FIREBIRD_PASSWORD'"
fi

if [ -n "$INPUT_ISC_PASSWORD" ]; then
    env_list="$env_list --env 'ISC_PASSWORD=$INPUT_ISC_PASSWORD'"
fi

if [ -n "$INPUT_TIMEZONE" ]; then
    env_list="$env_list --env 'TZ=$INPUT_TIMEZONE'"
fi

if [ -n "$INPUT_ENABLE_LEGACY_CLIENT_AUTH" ]; then
    env_list="$env_list --env 'EnableLegacyClientAuth=$INPUT_ENABLE_LEGACY_CLIENT_AUTH'"
fi

if [ -n "$INPUT_ENABLE_WIRE_CRYPT" ]; then
    env_list="$env_list --env 'EnableWireCrypt=$INPUT_ENABLE_WIRE_CRYPT'"
fi

if [ -n "$INPUT_DATA_TYPE_COMPATIBILITY" ]; then
    env_list="$env_list --env 'DataTypeCompatibility=$INPUT_DATA_TYPE_COMPATIBILITY'"
fi

docker_run="docker run --detach  --name '${INPUT_CONTAINER_NAME:-firebirdsql}' --publish '${INPUT_PORT:-3050}:3050' $env_list 'jacobalberty/firebird:${INPUT_VERSION:-latest}'"

echo "# Creating FirebirdSQL Container: $docker_run"

sh -c "$docker_run"
