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
    const evnt = config.events[i];
    console.log(">", evnt.sig);
    contract.events[evnt.sig]({
      filter: evnt.filters
    }, (e,r) => {
      if (e)
        console.log(e)
    })
    .on("data", (log) => fire(evnt, log))
    .on("changed", (log) => fire(evnt, log))
    .on("error", console.log);
  }
}

// Run mutations when an event fires
export const fire = (event, log) => {
  return blockMeta(log).then(meta => {
    return Object.assign(event.transform(log), meta)
  })
  .then(data => { return runMutations(event, data) })
  .catch(e => console.log(e));
}

const blockMeta = (log) => {
  return web3.eth.getBlock(log.blockNumber).then(block => {
    const ts = ( block ) ? block.timestamp : log.returnValues.timestamp;
    return {
      block: log.blockNumber,
      tx: log.transactionHash,
      time: ts,
      removed: log.removed
    }
  })
}

const runMutations = (event, data) => {
  return db.tx(t => {
    const sql = template => t.any(template, data)
    return t.batch(R.map(sql, event.mutate))
    .then(p => {
      // verbose logging
      console.log(event.sig, data);
      return p
    })
  })
}
