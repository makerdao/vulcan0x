import web3 from './web3';
import { db } from './db';
import { chain } from '../config/env';

const R = require('ramda');

// Subscribe to all events for a given contract
export const listen = (contract, events) => {
  for (var i=0, len = events.length; i < len; i++) {
    const evnt = events[i];
    console.log(">", evnt.sig);
    contract.events[evnt.sig]({
      filter: evnt.filters
    }, (e,r) => {
      if (e)
        console.log(e)
    })
    .on("data", (log) => fire(evnt, log, contract))
    .on("changed", (log) => fire(evnt, log, contract))
    .on("error", console.log);
  }
}

// Run mutations when an event fires
export const fire = (event, log, contract) => {
  return blockMeta(log).then(meta => {
    try {
      return event.transform(log, contract).then(log => {
        return Object.assign(log, meta)
      })
    }
    catch(e) {
      return Object.assign(event.transform(log, contract), meta)
    }
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
