import dapps from './dapps';
import { contract, listen } from './contract';
const argv = require('yargs').argv;

const subscribe = (name) => {
  console.log("Subscribe:", name)
  let dapp = contract(name);
  listen(dapp.connect, dapp.config);
}

if (argv.dapp) {
  subscribe('dapp/'+argv.dapp)
} else {
  dapps.forEach(subscribe);
}
