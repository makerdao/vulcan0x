INSERT INTO erc20.transfer (
  gem,
  src,
  dst,
  amt,
  block,
  time,
  tx
)
VALUES (
  ${gem},
  ${src},
  ${dst},
  ${amt},
  ${block},
  to_timestamp(${time}),
  ${tx}
)
ON CONFLICT ( tx )
DO NOTHING
