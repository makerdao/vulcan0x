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
  transform: function(log, contract) {
    return isOfferFilled(contract, log.returnValues.id)
    .then(filled => {
      return {
        idx: log.logIndex,
        filled: filled,
        id: id(log.returnValues.id),
        pair: log.returnValues.pair,
        maker: log.returnValues.maker,
        lot_gem: log.returnValues.pay_gem,
        bid_gem: log.returnValues.buy_gem,
        taker: log.returnValues.taker,
        lot_amt: wad(log.returnValues.take_amt, log.returnValues.pay_gem),
        bid_amt: wad(log.returnValues.give_amt, log.returnValues.buy_gem)
      }
    })
  },
  mutate: [
    sql("dapp/oasis/sql/tradeInsert"),
    sql("dapp/oasis/sql/offerUpdate")
  ]
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

const isOfferFilled = (contract, offerId) => {
  return contract.methods.getOffer(offerId).call()
    .then(data => {
      if(data[0] == "0" && data[2] == "0") {
        return true
      } else {
        return false
      }
    });
}

export const events = [make, take, kill]
