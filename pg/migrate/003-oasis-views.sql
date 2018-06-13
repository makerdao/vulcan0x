CREATE SCHEMA api;

CREATE VIEW api.oasis_offer AS
SELECT
  id,
  pair as pair_hash,
  (SELECT CONCAT(lot.symbol,'/',bid.symbol)) AS pair,
  maker,
  lot_gem,
  lot.symbol AS lot_tkn,
  lot_amt,
  bid_gem,
  bid.symbol AS bid_tkn,
  bid_amt,
  killed,
  block,
  time,
  tx
FROM oasis.offer o
LEFT JOIN oasis.token lot
  ON lot.address = o.lot_gem
LEFT JOIN oasis.token bid
  ON bid.address = o.bid_gem;

COMMENT ON COLUMN api.oasis_offer.id is 'Unique offer identifier';
COMMENT ON COLUMN api.oasis_offer.pair_hash is 'Trading pair hash';
COMMENT ON COLUMN api.oasis_offer.pair is 'Trading pair';
COMMENT ON COLUMN api.oasis_offer.maker is 'Offer creator address (msg.sender)';
COMMENT ON COLUMN api.oasis_offer.lot_gem is 'Lot token address';
COMMENT ON COLUMN api.oasis_offer.lot_tkn is 'Lot token symbol';
COMMENT ON COLUMN api.oasis_offer.lot_amt is 'Lot amount given';
COMMENT ON COLUMN api.oasis_offer.bid_gem is 'Bid token address';
COMMENT ON COLUMN api.oasis_offer.bid_tkn is 'Bid token symbol';
COMMENT ON COLUMN api.oasis_offer.bid_amt is 'Bid amount wanted';
COMMENT ON COLUMN api.oasis_offer.killed is '0 if the offer is live or block height when killed';
COMMENT ON COLUMN api.oasis_offer.block is 'Block height';
COMMENT ON COLUMN api.oasis_offer.time is 'Block timestamp';
COMMENT ON COLUMN api.oasis_offer.tx is 'Transaction hash';

CREATE VIEW api.oasis_trade AS
SELECT
  offer_id,
  pair as pair_hash,
  (SELECT CONCAT(lot.symbol,'/',bid.symbol)) AS pair,
  maker,
  taker,
  lot_gem,
  lot.symbol AS lot_tkn,
  lot_amt,
  bid_gem,
  bid.symbol AS bid_tkn,
  bid_amt,
  block,
  time,
  tx
FROM oasis.trade t
LEFT JOIN oasis.token lot
  ON lot.address = t.lot_gem
LEFT JOIN oasis.token bid
  ON bid.address = t.bid_gem;

COMMENT ON COLUMN api.oasis_trade.offer_id is 'Offer identifier';
COMMENT ON COLUMN api.oasis_trade.pair_hash is 'Trading pair hash';
COMMENT ON COLUMN api.oasis_trade.pair is 'Trading pair';
COMMENT ON COLUMN api.oasis_trade.maker is 'Offer creator address';
COMMENT ON COLUMN api.oasis_trade.taker is 'Trade creator address (msg.sender)';
COMMENT ON COLUMN api.oasis_trade.lot_gem is 'Lot token address';
COMMENT ON COLUMN api.oasis_trade.lot_tkn is 'Lot token symbol';
COMMENT ON COLUMN api.oasis_trade.lot_amt is 'Lot amount given by maker';
COMMENT ON COLUMN api.oasis_trade.bid_gem is 'Bid token address';
COMMENT ON COLUMN api.oasis_trade.bid_tkn is 'Bid token symbol';
COMMENT ON COLUMN api.oasis_trade.bid_amt is 'Bid amount matched by taker';
COMMENT ON COLUMN api.oasis_trade.block is 'Block height';
COMMENT ON COLUMN api.oasis_trade.time is 'Block timestamp';
COMMENT ON COLUMN api.oasis_trade.tx is 'Transaction hash';
