INSERT INTO oasis.trade (
  id,
  pair,
  guy,
  gem,
  lot,
  gal,
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
  ${gal},
  ${pie},
  ${bid},
  to_timestamp(${time}),
  ${block},
  ${tx},
)
