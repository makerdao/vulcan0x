import web3 from './web3';
import dapps from './dapps';
import { contract, fire } from './contract';
import { chain } from '../config';

const syncDapp = (name) => {
  console.log("Sync:", name)
  let dapp = contract(name);
  dapp.config.events.forEach(event => syncEvents(dapp, event));
}

const syncEvents = (dapp, event) => {
  console.log("Sync:", event.sig)
  web3.eth.getBlockNumber()
  .then(latest => {
    return {
      fromBlock: dapp.info[chain.id].firstBlock,
      toBlock: latest,
      filter: event.filters || {}
    }
  })
  .then(options => dapp.instance.getPastEvents(event.sig, options))
  .then(logs => logs.forEach(log => fire(event, log)))
  .catch(e => console.log(e));
}

dapps.forEach(syncDapp);
