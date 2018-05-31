const R = require('ramda');
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
    connect: new web3.eth.Contract(abi, config.info[chain.id].address)
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

// Run mutations when an event fires
export const fire = (event, log) => {
  return getBlock(log).then(block => {
    return Object.assign(event.transform(log), block)
  })
  .then(data => {
    return runMutations(event, data)
    .catch(e => console.log(e));
  })
  .catch(e => console.log(e));
}

const getBlock = (log) => {
  return web3.eth.getBlock(log.blockNumber).then(block => {
    return {
      block: log.blockNumber,
      tx: log.transactionHash,
      time: block.timestamp
    }
  })
}

const runMutations = (event, data) => {
  return db.tx(t => {
    const sql = template => t.any(template, data)
    return t.batch(R.map(sql, event.mutate))
    .then(p => {
      console.log(event.sig, data);
      return p
    })
  })
}
