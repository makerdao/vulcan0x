## vulcan0x Docker deployment

#### Setup

##### Prerequisite:

Install Docker: https://docs.docker.com/install/#server

Install docker-compose: https://docs.docker.com/compose/install/#install-compose

You can easily start your own ethereum node locally from Docker images by running:
- for Kovan (parity) node:
`docker run -d -it --name eth-node --restart always -v ~/eth-data:/root/.local -p 8546:8546 -p 8545:8545 -p 30303:30303 parity/parity --chain kovan --ws-port=8546 --ws-interface=all --ws-origins=all`

- for Mainnet node:
`docker run -d -it --name eth-node --restart always -v ~/eth-data:/root/.ethereum -p 8546:8546 -p 8545:8545 -p 30303:30303 ethereum/client-go --syncmode fast --ws --wsport 8546 --wsaddr 0.0.0.0 --wsorigins "*" --wsapi "eth,web3,shh"`

##### Configuration:

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
POSTGRES_USER=user
POSTGRES_PASSWORD=password
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=database
ETH_PROVIDER=ws://192.168.1.78:8546
ETH_CHAIN=kovan
```
Postgres and etehereum configurations can point to either local or remote deployments

##### Usage

-  Starting environment (that is starting all services:
PostgreSQL database, migrate and sync tasks, subscribe and graphql processes):
```
./start.sh
```
- Stopping environment:
```
./stop.sh
```
- To reset database abd rerun sync:
```
./resync.sh
```
- To update stack:
```
./update.sh
```

Alternate configurations can be specified by passing path to the `env` file, e.g.:
```
./start.sh .kovan.env
./update.sh .kovan.env
./resync.sh .kovan.env
./stop.sh .kovan.env
```

##### Development

You can change source code on your host machine, restart service and changes will be automatically applied inside Docker container.
E.g change code for `graphql` project then issue `docker restart graphql`

#### Other useful commands
- connect to psql command line: `./psql.sh`
- display all services and their status: `docker ps -a`
- see service logs: `docker logs -f postgres|sync|graphql|subscribe|migrate`
- restart service: `docker restart postgres|sync|graphql|subscribe|migrate`
