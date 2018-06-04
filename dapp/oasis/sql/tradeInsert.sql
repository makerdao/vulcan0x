INSERT INTO oasis.trade (
  offer_id,
  pair,
  maker,
  taker,
  lot_gem,
  bid_gem,
  lot_amt,
  bid_amt,
  block,
  time,
  tx
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
  ${block},
  to_timestamp(${time}),
  ${tx}
)
ON CONFLICT ( tx )
DO NOTHING
