import { chain, db } from '../config';

console.log("env:", process.env.NODE_ENV);
console.log("chain", chain);
console.log("database: postgres://", db.user, "@", db.host);

const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || chain.provider);

console.log("web3:", web3.version);

export default web3
