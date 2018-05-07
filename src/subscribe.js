import dapps from './dapps';
import { contract, listen } from './contract';

const subscribe = (name) => {
  console.log("Subscribe:", name)
  let dapp = contract(name);
  listen(dapp.instance, dapp.config);
}

dapps.forEach(subscribe);
