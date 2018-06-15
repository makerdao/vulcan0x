import web3 from './web3';
import { fire } from './contract';
import { dapps, chain } from '../config/env';

const sync = (id) => {
  deployments(id).forEach((dep) => {
    syncDapp(dep, id);
  });
}

const syncDapp = (dep, id) => {
  const abi = require(`../dapp/${id}/abi/${dep.key}.json`);
  const contract = new web3.eth.Contract(abi, dep.key)
  const transformer = require(`../dapp/${id}`);
  web3.eth.getBlockNumber().then(latest => {
    console.log("Latest block:", latest);
    transformer.events.forEach(event => batchEventSync(contract, event, dep.firstBlock, latest));
  })
  .catch(e => console.log(e));
}

const batchEventSync = (contract, event, firstBlock, latestBlock) => {
  const step = parseInt(process.env.BATCH) || 2000;
  const batches = (from, arr=[]) => {
    arr.push({from: from, to: from+step })
    if(latestBlock < from+step) {
      arr.push({from: from, to: latestBlock});
      return arr;
    } else
      return batches(from+step, arr);
  }
  require('bluebird').map(batches(firstBlock), (o) => {
    console.log(event.sig, o.from, o.to);
    return syncEvents(contract, event, o.from, o.to);
  }, {concurrency: 2})
  .then(() => console.log(event.sig, "batchSync complete"));
}

const syncEvents = (contract, event, from, to) => {
  const options = {
    fromBlock: from,
    toBlock: to,
    filter: event.filters || {}
  }
  return contract.getPastEvents(event.sig, options)
  .then(logs => logs.forEach(log => fire(event, log, contract)))
  .catch(e => console.log(e));
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
  sync(argv.dapp);
} else {
  dapps.forEach(sync);
}

