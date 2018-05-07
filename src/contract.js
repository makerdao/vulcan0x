import web3 from './web3';

// Given a config directory, instatiate a contract instance
export const contract = (path) => {
  const config = require(`../${path}`);
  const abi = require(`../${path}/abi/${config.address[process.env.CHAIN]}.json`);
  return {
    config: config,
    instance: new web3.eth.Contract(abi, config.address[process.env.CHAIN])
  }
}

// Subscribe to all events for a given contract
export const watch = (contract, config) => {
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
const fire = (event, log) => {
  return event.transform(log)
  .then(data => {
    lib.db.none(event.mutate, { data })
    console.log(data);
  })
  .catch(e => console.log(e));
}
