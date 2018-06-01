## Oasis GraphQL

An `Offer` represents a transaction created by msg.sender - `maker` to exchange
`lot` amount of ERC20 `gem` for `bid` amount of ERC20 `gem`. When an offer is
received the specified amount of offered `gem` is transferred from the `maker` to
the Oasis liquidity pool.

```graphql
type Offer {
  id:     Int      # unique id
  pair:   String   # pair hash
  maker:  String   # msg.sender
  lotGem: String   # lot gem address
  lotAmt: Float    # lot amount
  bidGem: String   # bid gem address
  bidAmt: Float    # bid amount
  block:  Int      # block number
  time:   Datetime # block timestamp
  tx:     String   # transaction hash
}
```

A `Trade` represents the matching of some portion of an `Offer` by msg.sender -
`taker` for `bid` amount of ERC20 `gem`. The appropriate amount of `gem` is
transferred from Oasis to `taker` whilst `bid` amount of ERC20 `gem` is transferred
from `taker` to the `maker`.  The corresponding `Offer` is updated with the new
`lot` amount. Once an order has been fully matched (`lot` goes to zero), it is deleted.

```graphql
type Trade {
  id:     Int      # unique id
  pair:   String   # pair hash
  maker:  String   # order maker
  taker:  String   # msg.sender
  lotGem: String   # lot gem address
  lotAmt: Float    # lot amount
  bidGem: String   # bid gem address
  bidAmt: Float    # bid amount
  block:  Int      # block number
  time:   Datetime # block timestamp
  tx:     String   # transaction hash
}
```

Query API

```graphql
type Query {
  getOffer(id: Int): {
    id
    pair
    maker
    lotGem
    lotAmt
    bidGem
    bidAmt
    block
    time
    tx
    history [Offer]
  }

  getTrade(id: Int, tx: String): {
    offer {
      id
      pair
      maker
      lotGem
      lotAmt
      bidGem
      bidAmt
    }
    pair
    maker
    taker
    lotGem
    lotAmt
    bidGem
    bidAmt
    block
    time
    tx
  }

  allOffers(condition: {}): [Offer]
  allOffersHistory(condition: {}): [Offer]

  allTrades(condition: {}): [Trade]
}
```
