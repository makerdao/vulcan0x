const { join } = require('path')
const fs = require('fs')
const env = process.env.ENV || '.env';

if (fs.existsSync(env)) {
  require('dotenv').config({path: env})
} else if (fs.existsSync(join(process.cwd(), env))) {
  require('dotenv').config({path: join(process.cwd(), env)})
} else {
  console.log(env, 'file not found')
  process.exit()
}

const pgSSL = process.env.POSTGRES_SSL == 'true' || false

const config = {
 chain: {
   provider: process.env.ETH_PROVIDER || 'wss://mainnet.infura.io/_ws',
   id: process.env.ETH_CHAIN || 'kovan'
 },
 db: {
   user: process.env.POSTGRES_USER,
   password: process.env.POSTGRES_PASSWORD,
   host: process.env.POSTGRES_HOST || 'localhost',
   port: parseInt(process.env.POSTGRES_PORT) || 5432,
   database: process.env.POSTGRES_DB || 'vulcan0x_kovan',
   ssl: pgSSL
 },
 express: {
   port: 4000,
   db: `postgres:\/\/${process.env.POSTGRES_USER}:${process.env.POSTGRES_PASSWORD}@${process.env.POSTGRES_HOST}:${process.env.POSTGRES_PORT}/${process.env.POSTGRES_DB}?ssl=${pgSSL}`
 }
};

module.exports = config;
