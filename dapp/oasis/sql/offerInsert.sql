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
  ${id},
  ${pair},
  ${guy},
  ${gem},
  ${lot},
  ${pie},
  ${bid},
  to_timestamp(${time}),
  ${block},
  ${tx}
)
