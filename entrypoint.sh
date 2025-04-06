#!/bin/sh

set -eu

#region Container Variables ------------------------------------------------------------

env_list=""

if [ -n "${INPUT_FIREBIRD_DATABASE:-}" ]; then
    env_list="${env_list} --env FIREBIRD_DATABASE=${INPUT_FIREBIRD_DATABASE}"
fi

if [ -n "${INPUT_FIREBIRD_USER:-}" ]; then
    env_list="${env_list} --env FIREBIRD_USER=${INPUT_FIREBIRD_USER}"
fi

if [ -n "${INPUT_FIREBIRD_PASSWORD:-}" ]; then
    env_list="${env_list} --env FIREBIRD_PASSWORD=${INPUT_FIREBIRD_PASSWORD}"
fi

if [ -n "${INPUT_FIREBIRD_ROOT_PASSWORD:-}" ]; then
    env_list="${env_list} --env FIREBIRD_ROOT_PASSWORD=${INPUT_FIREBIRD_ROOT_PASSWORD}"
fi

if [ -n "${INPUT_ISC_PASSWORD:-}" ]; then
    echo '# Setting isc_password on firebirdsql-github-action is deprecated. Use firebird_root_password instead.'
    env_list="${env_list} --env FIREBIRD_ROOT_PASSWORD=${INPUT_ISC_PASSWORD}"
fi

if [ -n "${INPUT_TIMEZONE:-}" ]; then
    env_list="${env_list} --env TZ=${INPUT_TIMEZONE}"
fi

if [ -n "${INPUT_ENABLE_LEGACY_CLIENT_AUTH:-}" ]; then
    echo '# Setting enable_legacy_client_auth on firebirdsql-github-action is deprecated. Use firebird_conf instead.'
    env_list="${env_list} --env FIREBIRD_USE_LEGACY_AUTH=${INPUT_ENABLE_LEGACY_CLIENT_AUTH}"
fi

if [ -n "${INPUT_ENABLE_WIRE_CRYPT:-}" ]; then
    echo '# Setting enable_wire_crypt on firebirdsql-github-action is deprecated. Use firebird_conf instead.'
    env_list="${env_list} --env FIREBIRD_CONF_WireCrypt=Enabled"
fi

if [ -n "${INPUT_DATA_TYPE_COMPATIBILITY:-}" ]; then
    echo '# Setting data_type_compatibility on firebirdsql-github-action is deprecated. Use firebird_conf instead.'
    env_list="${env_list} --env FIREBIRD_CONF_DataTypeCompatibility=${INPUT_DATA_TYPE_COMPATIBILITY}"
fi

OLD="${IFS}"; IFS=',';
for setting in ${INPUT_FIREBIRD_CONF:-}; do 
    printf '# Adding setting to firebird.conf: %s\n' "${setting}"; 
    env_list="${env_list} --env FIREBIRD_CONF_${setting}"
done
IFS="$OLD";

#endregion -----------------------------------------------------------------------------

#region Creation -----------------------------------------------------------------------

network_arg=''
if [ -n "${INPUT_NETWORK_NAME:-}" ]; then
    printf '# Using network: %s\n' "${INPUT_NETWORK_NAME}"; 
    network_arg="--network ${INPUT_NETWORK_NAME}"
fi

echo "# Creating the FirebirdSQL Container: docker run --detach --name ${INPUT_CONTAINER_NAME:-firebirdsql} --publish ${INPUT_PORT:-3050}:3050 ${env_list} firebirdsql/firebird:${INPUT_VERSION:-latest}"

# shellcheck disable=SC2086
if ! docker run --detach --name "${INPUT_CONTAINER_NAME:-firebirdsql}" --publish "${INPUT_PORT:-3050}:3050" ${network_arg} ${env_list} "firebirdsql/firebird:${INPUT_VERSION:-latest}" ; then
    echo "## Failed to create the FirebirdSQL container! ##"
    exit 11
fi

#endregion -----------------------------------------------------------------------------

#region Startup ------------------------------------------------------------------------

printf '# Waiting for %s to get ready...\n' "${INPUT_CONTAINER_NAME:-firebirdsql}"
for ii in $(seq 15 -2 1) ; do
    INSPECTED="$( docker container inspect -f '{{.State.Running}}' "${INPUT_CONTAINER_NAME:-firebirdsql}" )"
    if [ "${INSPECTED}" = "true" ] ; then break ; fi
    if test "${ii}" -le 1 ; then 
        printf '## Failed starting container for: %s\n' "${INPUT_CONTAINER_NAME:-firebirdsql}" ;
        exit 12;
    fi
    printf '.'; sleep "${ii}";
done

printf '# FirebirdSQL successfully started. Connect to "%s:%s" on port %s\n.' "${INPUT_CONTAINER_NAME:-firebirdsql}" "${INPUT_FIREBIRD_DATABASE:-my_database.fdb}" "${INPUT_PORT:-3050}"

exit 0

#endregion -----------------------------------------------------------------------------

## end of script ##
