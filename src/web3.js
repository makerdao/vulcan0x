import { chain } from '../config';

console.log(chain);

const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || chain.provider);

console.log("Web3:", web3.version);

export default web3
