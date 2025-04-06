# firebirdsql-github-action

This [GitHub Action](https://github.com/features/actions) sets up a [Firebird](https://www.firebirdsql.org) database running on a docker container.

## Usage

See more instructions in [Marketplace](https://github.com/marketplace/actions/setup-firebirdsql).

### Example

```yaml
steps:
- uses: juarezr/firebirdsql-github-action@v2
  with:
    version: 'latest'
    firebird_database: 'my_database.fdb'
    firebird_user: 'my_user'
    firebird_password: 'my_password'
```

See the FirebirdSQL [Docker Image](https://hub.docker.com/r/firebirdsql/firebird) for available tags/versions and also for more details on the [parameters](#parameters) that you can use.

### Connecting

For connecting your application to the FirebirdSQL database in your application, you may include the host IP address/DNS name and the path to the database as below:

- `localhost:my_database.fdb` to connect to the server running in the current job.
- `localhost:/var/lib/firebird/data/my_database.fdb` if you need to specify the full path.
- `<container name>:my_database.fdb` as alternative or if you have more than 1 container running at same time in the current job.

Example:

```sh
echo 'SELECT * FROM rdb$database;' | \ 
  isql -bail -quiet -echo -merge -m2 -z \
  -user 'my_user' -password 'my_password' \
  localhost:/var/lib/firebird/data/my_database.fdb
```

## Parameters

<!-- markdownlint-disable MD033 -->

`version`
> latest, 5, 5.0.2, 5-noble, 5-jammy, 4, 4.0.5, 3, 3.0.12, ...<br/>
> See the FirebirdSQL [Docker Image](https://hub.docker.com/r/firebirdsql/firebird) for available versions.
  and further details on input environment variables. Default: latest

`port`
> Optional port published in the host for connecting to the database. Default 3050.

`firebird_database`
> Optional name for creating a database with the container

`firebird_user`
> Optional name for creating a user that is database owner with the container.

`firebird_password`
> Optional password for the user created

`firebird_root_password`
> Default sysdba user password, if left blank Firebird installer generates a one-off password for SYSDBA instead.

`timezone`
> Optional Server TimeZone. (e.g.: America/Sao_Paulo)

`firebird_conf`
> Comma separated list of settings to be set in `firebird.conf`.<br/>
> E.g.: `ConnectionTimeout=180,DeadlockTimeout=10`.<br/>
> Spaces may break the container creation. To avoid, try to use single quotes for values if needed.<br/>
> Check the [firebird.conf documentation](https://firebirdsql.org/rlsnotesh/config-fb-conf.html) for details on the settings you can configure.

`container_name`
> Optional name for tagging the container. Default: `firebirdsql`.

`network_name`
> Optional name of the network for connecting the container

### Deprecated v1 parameters

`enable_legacy_client_auth`
> If this is set to "true" it will allow legacy clients to connect and authenticate.

`data_type_compatibility`
> Enable datatype compatibility for clients with previews versions: `4.x` and `3.x`.

`enable_wire_crypt`
> If this is set to "true" it will allow allow compatibility with Jaybird 3.

`isc_password`
> `isc_password` was removed. Use `firebird_root_password` instead.

### Notes

> [!WARNING]  
> if you use the `network_name` parameter above, the container may not answer on any of the `localhost`, `127.0.0.1`, or `0.0.0.0` addresses . Make sure you pass the IP address of the container on the added network.

## Misc

### Status

[![testing_changes](https://github.com/juarezr/firebirdsql-github-action/actions/workflows/testing_changes.yml/badge.svg)](https://github.com/juarezr/firebirdsql-github-action/actions/workflows/testing_changes.yml)

### License

The scripts and documentation in this project are released under the [GPL License](LICENSE)

### Funding

[<img alt="Send some cookies" src="http://img.shields.io/liberapay/receives/juarezr.svg?label=Send%20some%20cookies&logo=liberapay">](https://liberapay.com/juarezr/donate)
