import test from 'ava';
import contract from '../lib/contract';

test('parse contract manifest', t => {
  const oasis = contract('../dapp/oasis/manifest')
  t.is(oasis.events[0], 'foo');
})

