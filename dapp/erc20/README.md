## ERC20 GraphQL

Transfer events

```graphql
type erc20.Transfer {
  gem:   String   # ERC20 token address
  src:   String   # from address
  dst:   String   # to address
  amt:   Decimal  # amount
  block: Int      # block number
  time:  Datetime # block timestamp
  tx:    String   # transaction hash
}
```

Balances

```graphql
type erc20.Address {
  gem:   String   # ERC20 token address
  guy:   String   # account
  amt:   Decimal  # amount
  data:  String   # bytecode or null
  block: Int      # last updated block number
  time:  Datetime # last updated block timestamp
  tx:    String   # last updated transaction hash
}
```
