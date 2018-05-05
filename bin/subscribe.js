const oasis = require('../dapp/oasis/index');
const contract = new web3.eth.Contract(oasis.abi, oasis.address[process.env.CHAIN]);

const subscribe = (sig) => {
  contract.events[sig]({
    filter: { oasis[sig].filters }
  }, (e,r) => {
    if (e)
      console.log(e)
  })
  .on("data", (event) => mutate(event))
  .on("error", console.log);
}

const mutate = (event) => {
  return get(log)
  .then(data => {
    lib.db.none(mutation, { data })
    console.log(data);
  })
  .catch(e => console.log(e));
}
