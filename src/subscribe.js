import web3 from '../src/web3';
import { listen } from './contract';
import { dapps, chain } from '../config/env';

const subscribe = (id) => {
  deployments(id).forEach((dep) => {
    subscribeInit(dep, id);
  });
}

const subscribeInit = (dep, id) => {
  const abi = require(`../dapp/${id}/abi/${dep.key}.json`);
  const contract = new web3.eth.Contract(abi, dep.key)
  const transformer = require(`../dapp/${id}`);
  console.log("Subscribe", id);
  listen(contract, transformer.events);
}

//TODO modularize common sync & scribe init

const jp = require('jsonpath');
const argv = require('yargs').argv;
const dict = require('../config/dapps')

const deployments = (id) => {
  const dapp = jp.query(dict, `$.dapps[?(@.id=="${id}")]`);
  return jp.query(dapp, `$..[?(@.chain=="${chain.id}")]`);
}

if (argv.dapp) {
  subscribe(argv.dapp);
} else {
  dapps.forEach(subscribe);
}

