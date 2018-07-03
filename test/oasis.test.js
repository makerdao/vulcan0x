import web3 from '../src/web3';
import * as oasis from '../dapp/oasis';
import { fire } from '../src/contract';

import { db } from '../config/env';
import { migrate } from  'postgres-migrations'

const abi = require('../dapp/oasis/abi/0x14fbca95be7e99c15cc2996c6c9d841e54b79425.json');
const contract = new web3.eth.Contract(abi, '0x14fbca95be7e99c15cc2996c6c9d841e54b79425')

beforeAll(() => {
  return migrate(db, "pg/migrate")
});

describe('LogMake Event', () => {

  const log = require('./fixtures/oasis/LogMake');
  const fn =  oasis.events[0]

  test('sig', () => {
    expect(fn.sig).toBe('LogMake');
  });

  test('transform', () => {
    expect(fn.transform(log)).toEqual({
      id:      53804,
      pair:    "0x9dd48110dcc444fdc242510c09bbbbe21a5975cac061d82f7b843bce061ba391",
      maker:   "0x0005ABcBB9533Cf6F9370505ffeF25393E0D2852",
      lot_gem: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
      lot_amt: 24,
      bid_gem: "0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359",
      bid_amt: 18404.064
    });
  });

  test('mutate success', () => {
    expect.assertions(1);
    return expect(fire(fn, log)).resolves.toBeTruthy();
  });

})

describe('LogTake Event', () => {

  const log = require('./fixtures/oasis/LogTake');
  const fn =  oasis.events[1]

  test('transform', () => {
    expect.assertions(1);
    return expect(fn.transform(log, contract)).resolves.toEqual({
      id:      53724,
      idx:     9,
      filled:  true,
      pair:    "0x10aed75aa327f09ef87e5bdfaedf498ca260499a251ae5e049ddbd5e1633cd9c",
      maker:   "0x487E892B3C58507B5B41Eef397D8F7361E90027B",
      bid_gem: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
      lot_gem: "0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359",
      taker:   "0x004075e4D4b1ce6c48c81CC940e2bad24B489e64",
      lot_amt: 3760,
      bid_amt: 5
    });
  });

  test('mutate success', () => {
    expect.assertions(1);
    return expect(fire(fn, log, contract)).resolves.toBeTruthy();
  });

});

describe('LogKill Event', () => {

  const log = require('./fixtures/oasis/LogKill');
  const fn =  oasis.events[2]

  test('transform', () => {
    expect(fn.transform(log)).toEqual({
      id: 53795
    });
  });

  test('mutate success', () => {
    expect.assertions(1);
    return expect(fire(fn, log)).resolves.toBeTruthy();
  });

});
