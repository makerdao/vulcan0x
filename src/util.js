import web3 from 'web3'
import BigNumber from 'bignumber.js'
import { chain } from '../config/env';

const jp = require('jsonpath');
const tokens = require(`../config/tokens.${chain.id}`)

export const wad = (uint, gem) => {
  const token = jp.query(tokens, `$.erc20[?(@.key=="${gem}")]`)[0];
  if (!token) {
    console.log("Unrecognized erc20:", gem)
  }
  const dec = (token) ? token.decimals : 18
  return new BigNumber(uint).dividedBy(`1e${dec}`).toNumber()
}

export const id = (hex) => {
  return web3.utils.hexToNumber(hex)
}

const dapps = require('../config/dapps')

export const eachDeployment = (id, f) => {
  const dapp = jp.query(dapps, `$.dapps[?(@.id=="${id}")]`);
  jp.query(dapp, `$..[?(@.chain=="${chain.id}")]`)
    .forEach((deployment) => f(deployment, id));
}
