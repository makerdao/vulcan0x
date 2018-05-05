import test from 'ava';
import * as oasis from '../dapp/oasis/index'

test('LogTake id', t => {
	t.is(oasis.events[0].data({id: 999 }).id, 999);
});
