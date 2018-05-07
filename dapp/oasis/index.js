export const address = {
  mainnet: "0x14fbca95be7e99c15cc2996c6c9d841e54b79425",
  kovan: "0x8cf1Cab422A0b6b554077A361f8419cDf122a9F9"
}

const logMakeEvent = {
  sig: "LogMake",
  transform: function(log) {
    return {
      id: log.id,
      pair: log.pair,
      guy: log.maker,
      gem: log.pay_gem,
      pie: log.buy_gem,
      lot: log.pay_amt,
      bid: log.buy_amt
    }
  },
  mutate: ["offer-insert.sql"]
}

const logTakeEvent = {
  sig: "LogTake",
  transform: function(log) {
    return {
      id: log.id,
      pair: log.pair,
      guy: log.guy,
      gem: log.pay_gem,
      pie: log.buy_gem,
      gal: log.taker,
      lot: log.pay_amt,
      bid: log.buy_amt
    }
  },
  mutate: ["trade-insert.sql", "offer-update.sql"]
}

const logKillEvent = {
  sig: "LogKill",
  transform: function(log) {
    return {
      id: log.id
    }
  },
  mutate: ["offer-delete.sql"]
}

export const events = [logMakeEvent, logTakeEvent, logKillEvent]
