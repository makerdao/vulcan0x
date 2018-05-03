## Oasis GraphQL

An `Offer` represents a transaction created by msg.sender - `guy` to exchange
`lot` amount of ERC20 `gem` for `bid` amount of ERC20 `pie`. When an offer is
received the specified amount of offered `gem` is transferred from `guy` to the
Oasis liquidity pool.

```graphql
type Offer {
  id:    Int      # unique id
  pair:  String   # pair hash
  guy:   String   # msg.sender (maker)
  gem:   String   # gem address
  lot:   Float    # gem amount
  pie:   String   # pie address
  bid:   Float    # pie amount
  block: Int      # block number
  time:  Datetime # block timestamp
  tx:    String   # transaction hash
}
```

A `Trade` represents the matching of some portion of an `Offer` by msg.sender -
`gal` for `bid` amount of `pie`. The appropriate amount of `gem` is transferred
from Oasis to `gal` whilst `bid` amount of `pie` is transferred from `gal` to
`guy`.  The corresponding `Offer` is updated with the new `lot` amount. Once an
order has been fully matched (`lot` goes to zero), it is deleted.

```graphql
type Trade {
  id:    Int      # offer id (fk)
  pair:  String   # pair hash
  guy:   String   # maker
  gem:   String   # gem address
  lot:   Float    # gem amount
  gal:   String   # taker
  pie:   String   # pie address
  bid:   Float    # pie amount
  block: Int      # block number
  time:  Datetime # block timestamp
  tx:    String   # transaction hash
}
```

Query API

```graphql
type Query {
  getOffer(id: Int): {
    id
    pair
    guy
    gem
    lot
    pie
    bid
    block
    time
    tx
    history [Offer]
  }

  getTrade(id: Int, tx: String): {
    offer {
      id
      pair
      guy
      gem
      lot
      pie
      bid
    }
    pair
    guy
    gem
    lot
    gal
    pie
    bid
    block
    time
    tx
  }

  allOffers(condition: {}): [Offer]
  allOffersHistory(condition: {}): [Offer]

  allTrades(condition: {}): [Trade]
}
```
