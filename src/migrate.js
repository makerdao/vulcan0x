import { db } from '../config';

const pg = require('pg')
pg.defaults.ssl = true;

const {migrate} = require("postgres-migrations")

// TODO - check that the database exists
migrate(db, "pg/migrate")
.then(() => console.log("Migration complete"))
.catch((e) => console.log(e))
