require('dotenv').config()
const env = process.env.NODE_ENV;

const mainnet = {
 chain: {
   id: 'mainnet',
   provider: 'wss://mainnet.infura.io/_ws'
 },
 db: {
   user: process.env.MAIN_PGUSER,
   password: process.env.MAIN_PGPASSWORD,
   host: process.env.MAIN_PGHOST,
   port: parseInt(process.env.MAIN_PGPORT),
   database: process.env.MAIN_PGDATABASE
 }
};
const kovan = {
 chain: {
   id: 'kovan',
   provider: 'wss://kovan.infura.io/_ws'
 },
 db: {
   user: process.env.KOVAN_PGUSER,
   password: process.env.KOVAN_PGPASSWORD,
   host: process.env.KOVAN_PGHOST,
   port: parseInt(process.env.KOVAN_PGPORT),
   database: process.env.KOVAN_PGDATABASE
 }
};
const develop = {
 chain: {
   id: 'kovan',
   provider: 'wss://kovan.infura.io/_ws'
 },
 db: {
   user: process.env.DEVELOP_PGUSER,
   password: process.env.DEVELOP_PGPASSWORD,
   host: process.env.DEVELOP_PGHOST,
   port: parseInt(process.env.DEVELOP_PGPORT),
   database: process.env.DEVELOP_PGDATABASE
 }
};
const test = {
 chain: {
   id: 'test',
   provider: 'wss://kovan.infura.io/_ws'
 },
 db: {
   user: process.env.TEST_PGUSER,
   password: process.env.TEST_PGPASSWORD,
   host: process.env.TEST_PGHOST,
   port: parseInt(process.env.TEST_PGPORT),
   database: process.env.TEST_PGDATABASE
 }
};

const config = { mainnet, kovan, develop, test };

module.exports = config[env];
