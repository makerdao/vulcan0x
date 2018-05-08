import {sql} from '../../src/db';

export const info = {
  mainnet: {
    address: "0x14fbca95be7e99c15cc2996c6c9d841e54b79425",
    //firstBlock: 4861905
    firstBlock: 5572111
  },
  kovan: {
    address: "0x8cf1Cab422A0b6b554077A361f8419cDf122a9F9",
    firstBlock: 5216718
  }
}

const make = {
  sig: "LogMake",
  transform: function(log) {
    return {
      id: log.returnValues.id,
      pair: log.returnValues.pair,
      guy: log.returnValues.maker,
      gem: log.returnValues.pay_gem,
      pie: log.returnValues.buy_gem,
      lot: log.returnValues.pay_amt,
      bid: log.returnValues.buy_amt
    }
  },
  mutate: [sql("dapp/oasis/sql/offerInsert")]
}

const take = {
  sig: "LogTake",
  transform: function(log) {
    return {
      id: log.returnValues.id,
      pair: log.returnValues.pair,
      guy: log.returnValues.maker,
      gem: log.returnValues.pay_gem,
      pie: log.returnValues.buy_gem,
      gal: log.returnValues.taker,
      lot: log.returnValues.pay_amt,
      bid: log.returnValues.buy_amt
    }
  },
  mutate: [sql("dapp/oasis/sql/tradeInsert"), sql("dapp/oasis/sql/offerUpdate")]
}

const kill = {
  sig: "LogKill",
  transform: function(log) {
    return {
      id: log.returnValues.id
    }
  },
  mutate: [sql("dapp/oasis/sql/offerDelete")]
}

export const events = [make, take, kill]
