const oasis = require('../dapp/oasis/events');
console.log(oasis.events);

const subscribe = () => {
  tub.events.LogNote({
    filter: { sig: lib.act.cupSigs }
  }, (e,r) => {
    if (e)
      console.log(e)
  })
  .on("data", (event) => mutate(event))
  .on("error", console.log);
}

const mutate = () => {}
