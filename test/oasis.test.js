import * as oasis from '../dapp/oasis';

test('LogKill id', () => {
	expect(oasis.events[0].transform({id: 999}).id).toBe(999);
});
