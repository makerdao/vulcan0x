require('dotenv').config()

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
   database: process.env.MAIN_PGDATABASE,
   ssl: true
 },
 express: {
   port: 80,
   db: dbString
 }
};

const kovan = {
 chain: {
   id: 'kovan',
   provider: 'wss://kovan.infura.io/_ws' },
 db: {
   user: process.env.KOVAN_PGUSER,
   password: process.env.KOVAN_PGPASSWORD,
   host: process.env.KOVAN_PGHOST,
   port: parseInt(process.env.KOVAN_PGPORT),
   database: process.env.KOVAN_PGDATABASE,
   ssl: true
 },
 express: {
   port: 80,
   db: dbString
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
   database: process.env.DEVELOP_PGDATABASE,
   ssl: false
 },
 express: {
   port: 80,
   db: dbString
 }
};
const test = {
 chain: {
   id: 'mainnet',
   provider: 'wss://mainnet.infura.io/_ws'
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
   port: 80,
   db: dbString
 }
};

const envs = { mainnet, kovan, develop, test }
const config = envs[process.env.NODE_ENV];

const dbString = () => {
 return `postgres:\/\/${config.db.user}:${config.db.password}@${config.db.host}:${config.db.port}/${config.db.database}?ssl=${config.db.ssl}`
}

module.exports = config;
