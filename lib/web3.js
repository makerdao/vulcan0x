require('dotenv').config();

const prov = process.env.ETH_URL || 'wss://mainnet.infura.io/_ws';
const Web3 = require('web3');
const web3 = new Web3(Web3.givenProvider || prov);

export default web3
