import web3 from 'web3'
import BigNumber from 'bignumber.js'

export const wad = (uint, pow) => {
  const scale = pow || `1e18`;
  return new BigNumber(uint).dividedBy(scale).toNumber()
}

export const id = (hex) => {
  return web3.utils.hexToNumber(hex)
}
