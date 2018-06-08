INSERT INTO oasis.offer (
  id,
  pair,
  maker,
  lot_gem,
  lot_amt,
  bid_gem,
  bid_amt,
  removed,
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
  ${removed},
  ${block},
  to_timestamp(${time}),
  ${tx}
)
ON CONFLICT ( id )
DO UPDATE SET removed = ${removed}
