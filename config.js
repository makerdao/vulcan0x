require('dotenv').config()
const env = process.env.NODE_ENV;

const prod = {
 chain: {
   id: 'mainnet',
   provider: 'wss://mainnet.infura.io/_ws'
 },
 db: {
   user: process.env.KOVAN_PGUSER,
   password: process.env.KOVAN_PGPASSWORD,
   host: process.env.KOVAN_PGHOST,
   port: parseInt(process.env.KOVAN_PGPORT),
   database: process.env.KOVAN_PGDATABASE
 }
};
const dev = {
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

const config = {
 prod,
 dev,
 test
};

module.exports = config[env];
