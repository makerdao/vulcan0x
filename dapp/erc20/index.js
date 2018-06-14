import {sql} from '../../src/db';
import {wad, id} from '../../src/util';
import web3 from '../../src/web3';
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
    return getState(contract, log.returnValues.from, log.returnValues.to)
    .then(state => {
      return {
        gem:  info.mainnet.address,
        src:  log.returnValues.from,
        srcB: state.srcBalance,
        srcC: (state.srcData == '0x') ? false : true,
        dst:  log.returnValues.to,
        dstB: state.dstBalance,
        dstC: (state.dstData == '0x') ? false : true,
        amt:  wad(log.returnValues.value, `1e8`),
      }
    })
  },
  mutate: [
    sql("dapp/erc20/sql/transferInsert"),
    sql("dapp/erc20/sql/srcUpdate"),
    sql("dapp/erc20/sql/dstUpdate")
  ]
}

const getState = (contract, src, dst) => {
  return contract.methods.balanceOf(src).call().then(srcAmt => {
    return contract.methods.balanceOf(dst).call().then(dstAmt => {
      return web3.eth.getCode(src).then(srcData => {
        return web3.eth.getCode(dst).then(dstData => {
          return {
            srcBalance: wad(srcAmt, `1e8`),
            dstBalance: wad(dstAmt, `1e8`),
            srcData: srcData,
            dstData: dstData
          }
        })
      })
    })
  })
}

export const events = [transfer]
