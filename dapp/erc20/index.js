import {sql} from '../../src/db';
import {wad} from '../../src/util';
import web3 from '../../src/web3';

const transfer = {
  sig: "Transfer",
  transform: function(log, contract) {
    return getState(contract, log.returnValues.from, log.returnValues.to, log.address)
    .then(state => {
      return {
        gem:  log.address,
        src:  log.returnValues.from,
        srcB: state.srcBalance,
        srcC: (state.srcData == '0x') ? false : true,
        dst:  log.returnValues.to,
        dstB: state.dstBalance,
        dstC: (state.dstData == '0x') ? false : true,
        amt:  wad(log.returnValues.value, log.address),
      }
    })
  },
  mutate: [
    sql("dapp/erc20/sql/transferInsert"),
    sql("dapp/erc20/sql/srcUpdate"),
    sql("dapp/erc20/sql/dstUpdate")
  ]
}

const getState = (contract, src, dst, gem) => {
  return contract.methods.balanceOf(src).call().then(srcAmt => {
    return contract.methods.balanceOf(dst).call().then(dstAmt => {
      return web3.eth.getCode(src).then(srcData => {
        return web3.eth.getCode(dst).then(dstData => {
          return {
            srcBalance: wad(srcAmt, gem),
            dstBalance: wad(dstAmt, gem),
            srcData: srcData,
            dstData: dstData
          }
        })
      })
    })
  })
}

export const events = [transfer]
