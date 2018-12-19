/**
 * Migrate schema between version. I imagine that we could get rid of this for fresh deployments.
 */

import { chain } from '../config/env';
import { db, config } from './db';

const jp = require('jsonpath');
const tokens = require(`../config/tokens.${chain.id}`).erc20;
const markets = require(`../config/markets`).oasis;

// const pg = require('pg')
// pg.defaults.ssl = true;

const { migrate } = require("postgres-migrations")

migrate(config, "pg/migrate")
 .then(() => console.log("Migration complete"))
 .then(() => tokens.forEach(syncToken))
 .then(() => markets.forEach(syncMarket))
 .catch((e) => console.log(e))


const syncToken = (token) => {
  const args = [token.key, token.symbol, token.decimals, chain.id, token.desc]
  db.any(tokenSql, args)
    .then(() => console.log('Sync:', token))
    .catch(e => console.log(e))
}

const syncMarket = (mkt) => {
  const args = [mkt.id, mkt.base, mkt.quote]
  db.any(mktSql, args)
    .then(() => console.log('Market:', mkt))
    .catch(e => console.log(e))
}

const tokenSql = "INSERT INTO erc20.token(key,symbol,decimals,chain,name) \
  VALUES($1,$2,$3,$4,5) ON CONFLICT(key) DO UPDATE SET \
  (symbol,decimals,name)=($2,$3,$5)";

const mktSql = "INSERT INTO oasis.market(id,base,quote) \
  VALUES($1,$2,$3) ON CONFLICT(id) DO UPDATE SET \
  (base,quote)=($2,$3)";
