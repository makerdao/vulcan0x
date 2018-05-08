## vulcan0x

Cache contract data from the blockchain to PostgreSQL.

Reflect a GraphQL schema over the Postgres schema and serve over express.

Specify transformations for deployed contracts at `dapp/{contract}`

Add migrations to the global schema: `pg/migrate/001-init.sql`

End to end tests for `logEvent => postgresMutation`

```
npm run migrate
npm run sync
npm run subscribe
npm test
```
