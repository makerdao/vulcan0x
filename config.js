require('dotenv').config()

const mainnet = {
 chain: {
   id: 'mainnet',
   provider: process.env.MAINNET_PROVIDER || 'wss://mainnet.infura.io/_ws'
 },
 db: {
   user: process.env.MAINNET_PGUSER,
   password: process.env.MAINNET_PGPASSWORD,
   host: process.env.MAINNET_PGHOST,
   port: parseInt(process.env.MAINNET_PGPORT),
   database: process.env.MAINNET_PGDATABASE,
   ssl: true
 },
 express: {
   port: 4000,
   db: `postgres:\/\/${process.env.MAINNET_PGUSER}:${process.env.MAINNET_PGPASSWORD}@${process.env.MAINNET_PGHOST}:${process.env.MAINNET_PGPORT}/${process.env.MAINNET_PGDATABASE}?ssl=true`
 }
};

const kovan = {
 chain: {
   id: 'kovan',
   provider: process.env.KOVAN_PROVIDER || 'ws://localhost:8546'
 },
 db: {
   user: process.env.KOVAN_PGUSER,
   password: process.env.KOVAN_PGPASSWORD,
   host: process.env.KOVAN_PGHOST,
   port: parseInt(process.env.KOVAN_PGPORT),
   database: process.env.KOVAN_PGDATABASE,
   ssl: true
 },
 express: {
   port: 4000,
   db: `postgres:\/\/${process.env.KOVAN_PGUSER}:${process.env.KOVAN_PGPASSWORD}@${process.env.KOVAN_PGHOST}:${process.env.KOVAN_PGPORT}/${process.env.KOVAN_PGDATABASE}?ssl=true`
 }
};

const develop = {
 chain: {
   id: 'kovan',
   provider: process.env.DEVELOP_PROVIDER || 'ws://localhost:8546'
 },
 db: {
   user: process.env.DEVELOP_PGUSER,
   password: process.env.DEVELOP_PGPASSWORD,
   host: process.env.DEVELOP_PGHOST,
   port: parseInt(process.env.DEVELOP_PGPORT),
   database: process.env.DEVELOP_PGDATABASE,
   ssl: false
 },
 express: {
   port: 4000,
   db: `postgres:\/\/${process.env.DEVELOP_PGUSER}:${process.env.DEVELOP_PGPASSWORD}@${process.env.DEVELOP_PGHOST}:${process.env.DEVELOP_PGPORT}/${process.env.DEVELOP_PGDATABASE}?ssl=false`
 }
};
const test = {
 chain: {
   id: 'mainnet',
   provider: process.env.TEST_PROVIDER || 'wss://mainnet.infura.io/_ws'
 },
 db: {
   user: process.env.TEST_PGUSER,
   password: process.env.TEST_PGPASSWORD,
   host: process.env.TEST_PGHOST,
   port: parseInt(process.env.TEST_PGPORT),
   database: process.env.TEST_PGDATABASE,
   ssl: false
 },
 express: {
   port: 4000,
   db: `postgres:\/\/${process.env.TEST_PGUSER}:${process.env.TEST_PGPASSWORD}@${process.env.TEST_PGHOST}:${process.env.TEST_PGPORT}/${process.env.TEST_PGDATABASE}?ssl=false`
 }
};

const env = process.env.NODE_ENV || 'develop';
const envs = { mainnet, kovan, develop, test }
const config = envs[env];

module.exports = config;
