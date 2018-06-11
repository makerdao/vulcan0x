import {sql} from '../../src/db';
import {wad, id} from '../../src/util';

export const info = {
  mainnet: {
    address: "0x14fbca95be7e99c15cc2996c6c9d841e54b79425",
    firstBlock: 4861905
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
      id: id(log.returnValues.id),
      pair: log.returnValues.pair,
      maker: log.returnValues.maker,
      lot_gem: log.returnValues.pay_gem,
      bid_gem: log.returnValues.buy_gem,
      lot_amt: wad(log.returnValues.pay_amt),
      bid_amt: wad(log.returnValues.buy_amt)
    }
  },
  mutate: [sql("dapp/oasis/sql/offerInsert")]
}

const take = {
  sig: "LogTake",
  transform: function(log) {
    return {
      id: id(log.returnValues.id),
      pair: log.returnValues.pair,
      maker: log.returnValues.maker,
      lot_gem: log.returnValues.pay_gem,
      bid_gem: log.returnValues.buy_gem,
      taker: log.returnValues.taker,
      lot_amt: wad(log.returnValues.take_amt),
      bid_amt: wad(log.returnValues.give_amt)
    }
  },
  mutate: [sql("dapp/oasis/sql/tradeInsert")]
}

const kill = {
  sig: "LogKill",
  transform: function(log) {
    return {
      id: id(log.returnValues.id)
    }
  },
  mutate: [sql("dapp/oasis/sql/offerKill")]
}

export const events = [make, take, kill]
