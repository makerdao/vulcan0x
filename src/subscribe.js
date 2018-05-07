import dapps from './dapps';
import { contract, watch } from './contract';

const subscribe = () => {
  for (var i=0, len = dapps.length; i < len; i++) {
    console.log("Subscribe:", dapps[i])
    let c = contract(dapps[i]);
     watch(c.instance, c.config);
  }
}

subscribe();
