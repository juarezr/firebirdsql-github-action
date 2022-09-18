# firebirdsql-github-action

This [GitHub Action](https://github.com/features/actions) sets up a [Firebird](https://www.firebirdsql.org) database running on a docker container.

## Usage

See more instructions in [Marketplace](https://github.com/marketplace/actions/setup-firebirdsql).

### Example

```yaml
steps:
- uses: juarezr/firebirdsql-github-action@v1.2.0
  with:
    version: 'latest'
    firebird_database: 'my_database.fdb'
    firebird_user: 'my_user'
    firebird_password: 'my_password'
```

See [action.yml](action.yml) for more details

### Parameters

`version`
> latest, v4, v4.0, v4.0.2, v3, v3.0, v3.0.10, 2.5-ss, 2.5-sc<br/>
> See this [Docker Image](https://hub.docker.com/r/jacobalberty/firebird) for available versions.
  and further details on input environment variables

`port`
> Port published in the host for connecting in the database. Default 3050.

`firebird_database`
> Optional name for creating a database with the container

`firebird_user`
> Optional name for creating a user that is database owner with the container.

`firebird_password`
> Optional password for the user created

`isc_password`
> Default sysdba user password, if left blank a random 20 character password will be set instead.

`timezone`
> Optional Server TimeZone. (i.e. America/Sao_Paulo)

`enable_legacy_client_auth`
> If this is set to "true" it will allow legacy clients to connect and authenticate.

`data_type_compatibility`
> Enable datatype compatibility for clients with previews versions: `3.0` and `2.5`.

`enable_wire_crypt`
> If this is set to "true" it will allow allow compatibility with Jaybird 3.

`container_name`
> The name for tagging the container

## Misc

### Status

![testing_changes](https://github.com/juarezr/firebirdsql-github-action/workflows/testing_changes/badge.svg)

### License

The scripts and documentation in this project are released under the [GPL License](LICENSE)

### Funding

[<img alt="Send some cookies" src="http://img.shields.io/liberapay/receives/juarezr.svg?label=Send%20some%20cookies&logo=liberapay">](https://liberapay.com/juarezr/donate)
