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

See [action.yml](action.yml) for more details

### Parameters

`version`
> latest, 5, 5.0.2, 5-noble, 5-jammy, 4, 4.0.5, 3, 3.0.9, ...<br/>
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
> See: <https://firebirdsql.org/rlsnotesh/config-fb-conf.html>

`container_name`
> Optional name for tagging the container. Default: `firebirdsql`.

`network_name`
> Optional name of the network for connecting the container

#### Deprecated v1 parameters

`enable_legacy_client_auth`
> If this is set to "true" it will allow legacy clients to connect and authenticate.

`data_type_compatibility`
> Enable datatype compatibility for clients with previews versions: `3.0` and `2.5`.

`enable_wire_crypt`
> If this is set to "true" it will allow allow compatibility with Jaybird 3.

`isc_password`
> `isc_password` was removed. Use `firebird_root_password` instead.

## Misc

### Status

![testing_changes](https://github.com/juarezr/firebirdsql-github-action/workflows/testing_changes/badge.svg)

### License

The scripts and documentation in this project are released under the [GPL License](LICENSE)

### Funding

[<img alt="Send some cookies" src="http://img.shields.io/liberapay/receives/juarezr.svg?label=Send%20some%20cookies&logo=liberapay">](https://liberapay.com/juarezr/donate)
