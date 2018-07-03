INSERT INTO oasis.trade (
  offer_id,
  pair,
  maker,
  taker,
  lot_gem,
  bid_gem,
  lot_amt,
  bid_amt,
  removed,
  block,
  time,
  tx,
  idx
)
VALUES (
  ${id},
  ${pair},
  ${maker},
  ${taker},
  ${lot_gem},
  ${bid_gem},
  ${lot_amt},
  ${bid_amt},
  ${removed},
  ${block},
  to_timestamp(${time}),
  ${tx},
  ${idx}
)
ON CONFLICT (tx, idx)
DO UPDATE SET removed = ${removed}
