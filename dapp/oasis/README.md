## Oasis GraphQL

An `Offer` represents a transaction created by msg.sender - `maker` to offer
the exchange `lotAmt` of ERC20 `lotGem` for `bidAmt` of ERC20 `gem`. When an
offer is made the specified amount of offered `lotGem` is transferred from the
`maker` to the Oasis liquidity pool.

```graphql
type Offer {
  id:       Int      # unique id
  pair:     String   # e.g WETH/DAI
  pairHash: String   # keccak256(lotGem, bidGem)
  maker:    String   # msg.sender
  lotGem:   String   # lot gem address
  lotTkn:   String   # e.g WETH
  lotAmt:   Float    # lot amount
  bidGem:   String   # bid gem address
  bidTkn:   String   # e.g DAI
  bidAmt:   Float    # bid amount
  block:    Int      # block number
  time:     Datetime # block timestamp
  tx:       String   # transaction hash
}
```

A `Trade` represents the matching of some portion of an `Offer` by msg.sender -
`taker` for `bidAmt` of ERC20 `bidGem`. When a trade (take event) is made,
`lotAmt` of ERC20 `lotGem` is transferred from Oasis to `taker` whilst `bidAmt`
of ERC20 `bidGem` is transferred from `taker` to the `maker`.

```graphql
type Trade {
  offerId:  Int      # unique id
  pair:     String   # e.g WETH/DAI
  pairHash: String   # keccak256(lotGem, bidGem)
  maker:    String   # offer maker
  taker:    String   # msg.sender
  lotGem:   String   # lot gem address
  lotTkn:   String   # e.g WETH
  lotAmt:   Float    # lot amount
  bidGem:   String   # bid gem address
  bidTkn:   String   # e.g DAI
  bidAmt:   Float    # bid amount
  block:    Int      # block number
  time:     Datetime # block timestamp
  tx:       String   # transaction hash
}
```

Query API

```graphql
type Query {

  allOffers(filters: {}): [{
    id
    pair
    pairHash
    maker
    lotGem
    lotTkn
    lotAmt
    bidGem
    bidTkn
    bidAmt
    block
    time
    tx
    trades [Trade]
  }]

  allTrades(filters: {}): [{
    offer_id
    pair
    pairHash
    maker
    taker
    lotGem
    lotTkn
    lotAmt
    bidGem
    bidTkn
    bidAmt
    block
    time
    tx
    offer Offer
  }]

}
```
