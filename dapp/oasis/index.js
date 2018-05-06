//import timestamp from web3;
import web3 from "../lib/web3";

export const address = {
  mainnet: "0x14fbca95be7e99c15cc2996c6c9d841e54b79425",
  kovan:   "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

// const byteCode = {
//   web3.eth.getCode(address)
// }

export const abi = require('abi.json');

export const logKillEvent = {
  sig: "LogKill",
  filters:  {},
  transform: function(log) {
    return {
      id: log.id
    }
  },
  mutate: ["offer-delete.sql"]
}

export const logTakeEvent = {
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
  mutate: ["trade-insert.sql", "offer-update.sql"]
}
