import web3 from './web3';
import { fire } from './contract';
import { eachDeployment } from './util';
import { dapps } from '../config/env';

const sync = (opt, id) => {
  const abi = require(`../dapp/${id}/abi/${opt.key}.json`);
  const contract = new web3.eth.Contract(abi, opt.key)
  const transformer = require(`../dapp/${id}`);
  web3.eth.getBlockNumber().then(latest => {
    console.log("Latest block:", latest);
    transformer.events.forEach(event => batchSync(contract, event, opt.firstBlock, latest));
  })
  .catch(e => console.log(e));
}

const batchSync = (contract, event, firstBlock, latestBlock) => {
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
  }, {concurrency: 1})
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

const argv = require('yargs').argv;

if (argv.dapp) {
  eachDeployment(argv.dapp, sync);
} else {
  dapps.forEach((id) => eachDeployment(id, sync));
}
