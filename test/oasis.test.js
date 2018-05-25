import * as oasis from '../dapp/oasis';


const make = require('./fixtures/oasis/LogMake');

test('LogMake transform', () => {
	expect(oasis.events[0].transform(make)).toEqual({
    id:      53804,
    pair:    "0x9dd48110dcc444fdc242510c09bbbbe21a5975cac061d82f7b843bce061ba391",
    maker:   "0x0005ABcBB9533Cf6F9370505ffeF25393E0D2852",
    bid_gem: "0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359",
    lot_gem: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    lot_amt: 24,
    bid_amt: 18404.064
  });
});

const take = require('./fixtures/oasis/LogTake');

test('LogTake transform', () => {
	expect(oasis.events[1].transform(take)).toEqual({
    id:      53724,
    pair:    "0x10aed75aa327f09ef87e5bdfaedf498ca260499a251ae5e049ddbd5e1633cd9c",
    maker:   "0x487E892B3C58507B5B41Eef397D8F7361E90027B",
    bid_gem: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
    lot_gem: "0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359",
    taker:   "0x004075e4D4b1ce6c48c81CC940e2bad24B489e64",
    lot_amt: 5,
    bid_amt: 3760
  });
});

const kill = require('./fixtures/oasis/LogKill');

test('LogKill transform', () => {
	expect(oasis.events[2].transform(kill)).toEqual({
    id: 53795
  });
});
