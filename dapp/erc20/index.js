import {sql} from '../../src/db';
import {wad, id} from '../../src/util';
const argv = require('yargs').argv;

export const info = {
  mainnet: {
    address: argv.address || '0x168296bb09e24a88805cb9c33356536b980d3fc5',
    firstBlock: argv.firstBlock || 3383352
  }
}

const transfer = {
  sig: "Transfer",
  transform: function(log, contract) {
    return getBalances(contract, log.returnValues.from, log.returnValues.to)
    .then(amt => {
        return {
          gem:    info.mainnet.address,
          src:    log.returnValues.from,
          srcAmt: amt.src,
          dst:    log.returnValues.to,
          dstAmt: amt.dst,
          val:    log.returnValues.value,
          data:   null
        }
    })
  },
  mutate: [
    sql("dapp/erc20/sql/transferInsert"),
    sql("dapp/erc20/sql/srcUpdate"),
    sql("dapp/erc20/sql/dstUpdate")
  ]
}

const getBalances = (contract, src, dst) => {
  return contract.methods.balanceOf(src).call()
  .then(srcAmt => {
    return contract.methods.balanceOf(dst).call()
    .then(dstAmt => {
      return {
        src: wad(srcAmt, `1e8`),
        dst: wad(dstAmt, `1e8`)
      }
    })
  })
}

export const events = [transfer]
