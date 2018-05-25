import web3 from 'web3'
import BigNumber from 'bignumber.js'

export const wad = (uint) => {
  return new BigNumber(uint).dividedBy(`1e18`).toNumber()
}

export const id = (hex) => {
  return web3.utils.hexToNumber(hex)
}
