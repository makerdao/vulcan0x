import web3 from 'web3'
import BigNumber from 'bignumber.js'
import { chain } from '../config/env';

export const wad = (uint, pow) => {
  const scale = pow || `1e18`;
  return new BigNumber(uint).dividedBy(scale).toNumber()
}

export const id = (hex) => {
  return web3.utils.hexToNumber(hex)
}

const jp = require('jsonpath');
const dict = require('../config/dapps')

export const eachDeployment = (id, f) => {
  const dapp = jp.query(dict, `$.dapps[?(@.id=="${id}")]`);
  jp.query(dapp, `$..[?(@.chain=="${chain.id}")]`)
    .forEach((deployment) => f(deployment, id));
}
