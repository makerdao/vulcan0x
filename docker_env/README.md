## vulcan0x Docker deployment

#### Setup

###### Prerequisite:

Install Docker: https://docs.docker.com/install/#server

Install docker-compose: https://docs.docker.com/compose/install/#install-compose

You can attach current stack to an existing ethereum node or to an local synced one.
You can easily start your own ethereum node locally from Docker images by running:
- for Kovan (parity) node:  
`docker run -d -it --name eth-node --restart always -v ~/eth-data:/root/.local -p 8546:8546 -p 8545:8545 -p 30303:30303 parity/parity --chain kovan --ws-port=8546 --ws-interface=all --ws-origins=all`

- for Mainnet node:  
`docker run -d -it --name eth-node --restart always -v ~/eth-data:/root/.ethereum -p 8546:8546 -p 8545:8545 -p 30303:30303 ethereum/client-go --syncmode fast --ws --wsport 8546 --wsaddr 0.0.0.0 --wsorigins "*" --wsapi "eth,web3,shh"`  

If you start node from Docker image you have to create a network and connect node to it (vulcan0x stack will use same network):
```
docker network create eth-net
docker network connect eth-net eth-node
```

Docker environment starts following services (on the same machine or on targeted
machine in case specified):
- PostgreSQL database
- migrate and sync task
- subscribe and graphql processes

For starting environment:
- `git clone https://github.com/makerdao/vulcan0x.git`
- add `.env` file in `vulcan0x/docker_env` directory containing
PostgreSQL configuration details,  e.g `docker_env/.env`:
```
POSTGRES_DB=vulcan0xdb
POSTGRES_USER=vulcan0xadmin
POSTGRES_PASSWORD=vulcan0xadminchangepassword
```
- add `.vulcan0x-env` file in same `vulcan0x/docker_env` directory containing
connection details for vulcan0x (should match PostgreSQL configuration from  `.env` file) e.g `docker_env/.vulcan0x-env`
```
KOVAN_PGHOST=postgres
KOVAN_PGUSER=vulcan0xadmin
KOVAN_PGPASSWORD=vulcan0xadminchangepassword
KOVAN_PGPORT=5432
KOVAN_PGDATABASE=vulcan0xdb
KOVAN_PROVIDER=ws://eth-node:8546
```
Valid environments are `mainnet`, `kovan`, `develop` and `test`.
(see `config.js` for additional context)

#### Usage

Note: the required environment should be specified by exporting `NODE_ENV` as an environment variable before running scripts:

`export NODE_ENV=kovan`
or
`export NODE_ENV=mainnet`

Starting environment (that is starting all services:
PostgreSQL database, migrate and sync tasks, subscribe and graphql processes):

```
./start.sh
```

Stopping environment:

```
./stop.sh
```

To check for updates and apply them on an running environment:

```
./update.sh
```

#### Other useful commands
- connect to psql command line: `docker exec -it postgres psql -U vulcan0xadmin vulcan0xdb`
- dump PostgreSQL data: `docker exec -u postgres postgres pg_dumpall -c > dump.sql`
- display all services and their status: `docker ps -a`
- see service logs: `docker logs -f postgres|sync|graphql|subscribe|migrate`
- restart service: `docker restart postgres|sync|graphql|subscribe|migrate`
