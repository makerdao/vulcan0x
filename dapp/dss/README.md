## Dai Stablecoin GraphQL

Vat - System state

```graphql
type Vat {
  line:  Int      # total debt ceiling
  tab:   Float    # total debt
  lump:  Float    # auction lot size
  wait:  Int      # sin queue wait period
  block: Int      # block number
  time:  Datetime # block timestamp
  tx:    String   # transaction hash
}
```

Ilk - CDP type record

```graphql
type Ilk {
  id:    Int      # ilk id
  spot:  Float    # liquidation factor
  rate:  Float    # accumulated rates
  line:  Float    # debt ceiling
  chop:  Float    # ???
  art:   Float    # total debt owed by CDPs of this type
  flip:  String   # liquidator address
  act:   String   # update action, form | file
  block: Int      # block number
  time:  Datetime # block timestamp
  tx:    String   # transaction hash
}
```

bool safe = rmul(u.ink, i.spot) >= rmul(u.art, i.rate);

Urn - CDP record

```graphql
type Urn {
  ilk:   Int      # ilk id
  lad:   String   # cdp owner address
  gem:   Float    # ???
  ink:   Float    # locked gem
  art:   Float    # debt
  pip:   Float    # reference price
  block: Int      # block number
  time:  Datetime # block timestamp
  tx:    String   # transaction hash
);
```
