require('dotenv').config()

const pg = require('pg')
pg.defaults.ssl = true;

const {migrate} = require("postgres-migrations")

// TODO - check that the database exists
migrate({
    database: process.env.PGDATABASE,
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    host: process.env.PGHOST,
    port: parseInt(process.env.PGPORT)
  }, "pg/migrate"
)
.then(() => {
  console.log("Migration complete")
})
.catch((e) => {
  console.log(e)
})
