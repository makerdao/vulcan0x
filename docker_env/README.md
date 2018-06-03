## vulcan0x Docker deployment

#### Setup

Docker environment starts following services (on the same machine or on targeted
machine in case specified):
- PostgreSQL database
- migrate and sync task
- subscribe and graphql processes

For starting environment - place a `.env` file in `docker_env` directory containing
PostgreSQL configuration details,  e.g `docker_env/.env`
```
POSTGRES_DB=vulcan0xdb
POSTGRES_USER=vulcan0xadmin
POSTGRES_PASSWORD=vulcan0xadminchangepassword
```
and a `.vulcan0x-env` file in same `docker_env` directory containing
connection details for vulcan0x (should match PostgreSQL configuration from  `.env` file).
Valid environments are `mainnet`, `kovan`, `develop` and `test`.

(see `config.js` for additional context)

e.g `docker_env/.vulcan0x-env`
```
KOVAN_PGHOST=postgres
KOVAN_PGUSER=vulcan0xadmin
KOVAN_PGPASSWORD=vulcan0xadminchangepassword
KOVAN_PGPORT=5432
KOVAN_PGDATABASE=vulcan0xdb
KOVAN_PROVIDER=ws://eth-node:8546
```

#### Usage

Note: the required environment should be specified by exporting `NODE_ENV` as an environment variable before running scripts:

`export NODE_ENV=kovan`

Starting environment (that is starting all services:
PostgreSQL database, migrate and sync tasks, subscribe and graphql processes):

```
./start.sh
```

Stopping environment:

```
./stop.sh
```

To check for updates and apply them on an running environment:

```
./update.sh
```