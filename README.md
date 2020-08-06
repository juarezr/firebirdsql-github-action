# firebirdsql-github-action
This [GitHub Action](https://github.com/features/actions) sets up a FirebirdSQL database running on a docker container.

# Usage

See [action.yml](action.yml)

Basic:
```yaml
steps:
- uses: juarezr/firebirdsql-github-action@v1
  with:
    firebirdsql version: 'latest'  # See https://hub.docker.com/r/jacobalberty/firebird for available versions
    firebirdsql database: 'my_database'
    firebirdsql username: 'my_user'
    firebirdsql password: 'my_password'
```

# License

The scripts and documentation in this project are released under the [GPL License](LICENSE)
