INSERT INTO erc20.balance (
  gem,
  lad,
  amt,
  code,
  block,
  time,
  tx
)
VALUES (
  ${gem},
  ${src},
  ${srcB},
  ${srcC},
  ${block},
  to_timestamp(${time}),
  ${tx}
)
ON CONFLICT (gem, lad)
DO UPDATE SET
  amt = ${srcB},
  block = ${block},
  time = to_timestamp(${time}),
  tx = ${tx};
