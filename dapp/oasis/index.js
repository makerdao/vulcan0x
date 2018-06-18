import {sql} from '../../src/db';
import {wad, id} from '../../src/util';

const make = {
  sig: "LogMake",
  transform: function(log) {
    return {
      id: id(log.returnValues.id),
      pair: log.returnValues.pair,
      maker: log.returnValues.maker,
      lot_gem: log.returnValues.pay_gem,
      bid_gem: log.returnValues.buy_gem,
      lot_amt: wad(log.returnValues.pay_amt, log.returnValues.pay_gem),
      bid_amt: wad(log.returnValues.buy_amt, log.returnValues.buy_gem)
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
      lot_amt: wad(log.returnValues.take_amt, log.returnValues.pay_gem),
      bid_amt: wad(log.returnValues.give_amt, log.returnValues.buy_gem)
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

// Mutations not implemented
const addToken = {
  sig: "LogAddTokenPairWhitelist",
  transform: function(log) {
    return {
      base: log.returnValues.baseToken,
      quote: log.returnValues.quoteToken
    }
  },
  mutate: [sql("dapp/oasis/sql/insertBase.sql"), sql("dapp/oasis/sql/insertQuote.sql")]
}

export const events = [make, take, kill]
