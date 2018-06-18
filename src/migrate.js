import { chain } from '../config/env';
import { db, config } from './db';

const jp = require('jsonpath');
const tokens = require(`../config/tokens.${chain.id}`).erc20

// const pg = require('pg')
// pg.defaults.ssl = true;

const { migrate } = require("postgres-migrations")

migrate(config, "pg/migrate")
 .then(() => console.log("Migration complete"))
 .then(() => tokens.forEach(syncToken))
 .catch((e) => console.log(e))


const syncToken = (token) => {
  const args = [token.key, token.symbol, token.decimals, chain.id, token.desc]
  db.any(sql, args)
    .then(() => console.log('Sync:', token))
    .catch(e => console.log(e))
}

const sql = "INSERT INTO erc20.token(key,symbol,decimals,chain,name) \
  VALUES($1,$2,$3,$4,5) ON CONFLICT(key) DO UPDATE SET \
  (symbol,decimals,name)=($2,$3,$5)";
