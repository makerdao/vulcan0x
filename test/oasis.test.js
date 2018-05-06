import * as oasis from '../dapp/oasis/index.js';

test('LogTake id', t => {
	t.is(oasis.events[0].data({id: 999 }).id, 999);
});
