INSERT INTO oasis.offer (
  id,
  pair,
  guy,
  gem,
  lot,
  pie,
  bid,
  block,
  time,
  tx
)
VALUES (
  ${event.id},
  ${event.pair},
  ${event.maker},
  ${event.pay_gem},
  ${event.give_amt},
  ${event.buy_gem},
  ${event.take_amt},
  to_timestamp(${event.timestamp}),
  ${event.blockNumber},
  ${event.transactionHash},
)
