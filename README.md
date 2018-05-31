## vulcan0x

Cache contract data from the blockchain to PostgreSQL.

Reflect a GraphQL schema over the Postgres schema and serve via express.

Specify transformations for watched contracts at `dapp/{contract}`

#### Setup

The application expects a `.env` file in the root directory containing
connection details for as many environments as required:

Valid environments are `mainnet`, `kovan`, `develop` and `test`.

(see `config.js` for additional context)

e.g vulcan0x/.env
```
KOVAN_PGHOST=localhost
KOVAN_PGUSER=username
KOVAN_PGPASSWORD=password
KOVAN_PGPORT=5432
KOVAN_PGDATABASE=database
KOVAN_PROVIDER=ws://localhost:8546

MAINNET_PGHOST=localhost
MAINNET_PGUSER=username
MAINNET_PGPASSWORD=password
MAINNET_PGPORT=5432
MAINNET_PGDATABASE=database
MAINNET_PROVIDER=ws://localhost:8546

TEST_PGHOST=localhost
TEST_PGUSER=username
TEST_PGPASSWORD=password
TEST_PGPORT=5432
TEST_PGDATABASE=database
```

#### Usage

Note: the required environment should be specified by setting `NODE_ENV`:

`NODE_ENV=kovan npm run sync`

Ad-hoc commands:

```
npm run migrate - run pending database migrations
npm run sync - sync log event history from the blockchain to postgres
npm test - run the test suite
```

Running processes:

```
npm run subscribe - subscribe to new log events on watched contracts
npm run graphql - run the graphql server over localhost
```
