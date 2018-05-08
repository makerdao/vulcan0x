require('dotenv').config()

const pgp = require('pg-promise')()
const path = require('path')

const db = pgp({
  user: process.env.PGUSER,
  password: process.env.PGPASSWORD,
  host: process.env.PGHOST,
  port: process.env.PGPORT,
  database: process.env.PGDATABASE,
  ssl: true
});

function sql(file) {
  const fullPath = path.join(__dirname, '../'+file+'.sql');
  return new pgp.QueryFile(fullPath, { minify: true });
}

export { db, sql }
