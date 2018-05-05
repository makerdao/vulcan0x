//import timestamp from web3;

const address = {
  mainnet: "0x",
  kovan: "0x"
}

const abi = require('abi.json');

const logKillEvent = {
  sig: "LogKill",
  filters:  {},
  transform: function(log) {
    return {
      id: log.id
    }
  },
  mutate: ["deleteOffer.sql"]
}

const logTakeEvent = {
  sig: "LogKill",
  filters:  {},
  transform: function(log) {
    return {
      id: log.id,
      pair: log.pair,
      maker: log.guy,
      gem: log.pay_gem,
      pie: log.buy_gem,
      lot: log.pay_amt,
      bid: log.buy_amt,
      //time: web3.eth.getBlock(log.blockNumber).timestamp,
      block: log.blockNumber,
      tx: log.transactionHash
    }
  },
  mutate: ["insertTrade.sql", "updateOffer.sql"]
}

module.exports = {
  abi: abi,
  address: address,
  events: []
}
