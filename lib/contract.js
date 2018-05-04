const contract = (manifestPath) => {
  const manifest = require(manifestPath);
  return manifest
}

const sync = () => {}

const subscribe = () => {}

const LogMake.transform = (log) => {
  return {
    id: log.id,
    pair: log.pair,
    maker: log.guy,
    gem: log.pay_gem,
    pie: log.buy_gem,
    lot: log.pay_amt,
    bid: log.buy_amt,
    time: web3.eth.getBlock(log.blockNumber).timestamp,
    block: log.blockNumber,
    tx: log.transactionHash
  }
}

Oasis.events.each => e
  web3.eth.subscribe(e)
  on.data => transform(e, data)

const subscribe () =>


const transform = (dapp, event) => {


}

npm run subscribe Oasis

// Shared, generic
const put = (log, mutation) => {
  return get(log)
  .then(data => {
    lib.db.none(mutation, { data })
    console.log(data);
  })
  .catch(e => console.log(e));
}

module.exports = contract;
