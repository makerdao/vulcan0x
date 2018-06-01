import web3 from './web3';
import dapps from './dapps';
import { contract, fire } from './contract';
import { chain } from '../config';

const syncDapp = (name) => {
  console.log("Contract:", name, "-------------------")
  let dapp = contract(name);
  web3.eth.getBlockNumber()
  .then(latest => {
    console.log("Latest block:", latest);
    dapp.config.events.forEach(event => batchEventSync(dapp, event, latest));
  })
  .catch(e => console.log(e));
}

const batchEventSync = (dapp, event, latestBlock) => {
  const step = parseInt(process.env.BATCH) || 50000;
  const firstBlock = parseInt(dapp.info[chain.id].firstBlock);
  const batches = (from, arr=[]) => {
    arr.push({from: from, to: from+step })
    if(latestBlock < from+step) {
      arr.push({from: from, to: latestBlock});
      return arr;
    } else
      return batches(from+step, arr);
  }
  const contract = dapp.connect;
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
  .then(logs => logs.forEach(log => fire(event, log)))
  .catch(e => console.log(e));
}

dapps.forEach(syncDapp);
