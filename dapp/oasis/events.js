//import timestamp from web3;

const LogMake = {
  data: function(log) {
    return {
      id: log.id
    }
  },
  mutations: ["insertOffer.sql"]
}

//const LogTake = {
//  return {
//    data: {
//      id: log.id,
//      pair: log.pair,
//      maker: log.guy,
//      gem: log.pay_gem,
//      pie: log.buy_gem,
//      lot: log.pay_amt,
//      bid: log.buy_amt,
//      //time: web3.eth.getBlock(log.blockNumber).timestamp,
//      block: log.blockNumber,
//      tx: log.transactionHash
//    },
//    mutations: ["insertTrade.sql", "updateOffer.sql"]
//  }
//}

//const LogKill = {
//  return {
//    data: function(log) {
//      return {
//        id: log.id,
//      }
//    },
//    mutations: ["deleteOffer.sql"]
//  }
//}

module.exports = {
  address: {
    mainnet: "0x14fbca95be7e99c15cc2996c6c9d841e54b79425"
  },
  events: [LogMake]
}
