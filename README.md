## vulcan0x

Cache contract data from the blockchain to PostgreSQL.

Reflect a GraphQL schema over the Postgres schema and serve via express.

Specify transformations for watched contracts at `dapp/{contract}`

### Setup

Connection details for Postgres and Ethereum are expected to be defined as
environment variables. By default the application will expect a `.env` file
located in the root directory containing these connection details.

e.g vulcan0x/.env
```
POSTGRES_USER=user
POSTGRES_PASSWORD=password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=database

ETH_PROVIDER=ws://localhost:8546
ETH_CHAIN=kovan

DAPPS=oasis:erc20 # specify which watchers to run on sync & subscribe
```

Alternate configurations can be specified by setting `ENV` when invoking scripts:

Pass the name of the `env` file when located in the root directory:

```
ENV=.mainnet.env npm run subscribe
```

Or a fullpath to the `env` if located outside of the root directory:

```
ENV=/path/to/file/.kovan.env npm run sync
ENV=/path/to/file/.test.env npm run sync
ENV=/path/to/file/.develop.env npm run sync
```

### Usage

Ad-hoc commands:

* `npm run migrate` - run pending database migrations
* `npm run sync` - sync log event history from the blockchain to postgres
* `npm test` - run the test suite

Running processes:

* `npm run subscribe` - subscribe to new log events on all watched contracts
* `npm run graphql` - run the graphql server over localhost

Options:

The `sync` and `subscribe` commands can be used without options to run against
all contracts in the `dapp` folder or with the `--dapp` flag to run against a
particular contract.

`npm run sync -- --dapp=oasis`

### Development

```sh
./scripts/start-dev.sh
```