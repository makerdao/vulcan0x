import web3 from './web3';
import {db} from './db';
import { chain } from '../config';

// Given a config directory, instantiate a contract instance
export const contract = (path) => {
  const config = require(`../${path}`);
  const abi = require(`../${path}/abi/${config.info[chain.id].address}.json`);
  return {
    config: config,
    info: config.info,
    instance: new web3.eth.Contract(abi, config.info[chain.id].address)
  }
}

// Subscribe to all events for a given contract
export const listen = (contract, config) => {
  for (var i=0, len = config.events.length; i < len; i++) {
    contract.events[config.events[i].sig]({
      filter: config.events[i].filters
    }, (e,r) => {
      if (e)
        console.log(e)
    })
    .on("data", (log) => fire(config.events[i], log))
    .on("error", console.log);
  }
}

// Trigger a mutation when an event fires
export const fire = (event, log, dir) => {
  return txMeta(log).then(meta => {
    return Object.assign(event.transform(log), meta)
  })
  .then(data => {
    console.log(data);
    //return db.none(event.mutate[0], data)
  })
  .catch(e => console.log(e));
}

export const txMeta = (log) => {
  return web3.eth.getBlock(log.blockNumber).then(block => {
    return {
      block: log.blockNumber,
      tx: log.transactionHash,
      time: block.timestamp
    }
  })
}


