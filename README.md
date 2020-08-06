# firebirdsql-github-action
This [GitHub Action](https://github.com/features/actions) sets up a FirebirdSQL database running on a docker container.

# Usage

## Basic

Example:

```yaml
steps:
- uses: juarezr/firebirdsql-github-action@v1
  with:
    version: 'latest'
    firebirdsql_database: 'my_database.fdb'
    firebirdsql_username: 'my_user'
    firebirdsql_password: 'my_password'
```

See [action.yml](action.yml) for more details

## Paremeters

version
: 3.0 (latest), 4.0 (beta), 2.5-ss, 2.5-cs (Legacy)
: See this [Docker Image](https://hub.docker.com/r/jacobalberty/firebird) for available versions 
  and further details on input environment variables

port
: Port published in the host for connecting in the database. Default 3050.

firebird_database
: Optional name for creating a database with the container

firebird_user
: Optional name for creating a user that is database owner with the container

firebird_password
: Optional password for the user created

isc_password
: Default sysdba user password, if left blank a random 20 character password will be set instead.

timezone
: Optional Server TimeZone. (i.e. America/Sao_Paulo)

enable_legacy_client_auth
: If this is set to "true" it will allow legacy clients to connect and authenticate.

enable_wire_crypt
: If this is set to "true" it will allow allow compatibility with Jaybird 3.

container_name
: The name for tagging the container

# License

The scripts and documentation in this project are released under the [GPL License](LICENSE)
