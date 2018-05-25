INSERT INTO offer (
  id,
  pair,
  maker,
  lot_gem,
  lot_amt,
  bid_gem,
  bid_amt,
  block,
  time,
  tx
)
VALUES (
  ${id},
  ${pair},
  ${maker},
  ${lot_gem},
  ${lot_amt},
  ${bid_gem},
  ${bid_amt},
  999,
  to_timestamp(11234),
  'asdf'
)
ON CONFLICT ( id )
DO NOTHING
