CREATE SCHEMA oasis;

CREATE TABLE oasis.offer (
  id         integer primary key,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal,
  bid_gem    character varying(66),
  bid_amt    decimal,
  removed    boolean,
  killed     integer default 0,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) not null
);

COMMENT ON COLUMN oasis.offer.id is 'Unique offer identifier';
COMMENT ON COLUMN oasis.offer.pair is 'Trading pair hash';
COMMENT ON COLUMN oasis.offer.maker is 'Offer creator address (msg.sender)';
COMMENT ON COLUMN oasis.offer.lot_gem is 'Lot token address';
COMMENT ON COLUMN oasis.offer.lot_amt is 'Lot amount given';
COMMENT ON COLUMN oasis.offer.bid_gem is 'Bid token address';
COMMENT ON COLUMN oasis.offer.bid_amt is 'Bid amount wanted';
COMMENT ON COLUMN oasis.offer.killed is '0 if the offer is live or block height when killed';
COMMENT ON COLUMN oasis.offer.block is 'Block height';
COMMENT ON COLUMN oasis.offer.time is 'Block timestamp';
COMMENT ON COLUMN oasis.offer.tx is 'Transaction hash';

CREATE INDEX oasis_offer_pair_index ON oasis.offer(pair);
CREATE INDEX oasis_offer_maker_index ON oasis.offer(maker);
CREATE INDEX oasis_offer_killed_index ON oasis.offer(killed);

CREATE TABLE oasis.trade (
  offer_id   integer,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal,
  taker      character varying(66),
  bid_gem    character varying(66),
  bid_amt    decimal,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) unique not null
);

COMMENT ON COLUMN oasis.trade.offer_id is 'Offer identifier';
COMMENT ON COLUMN oasis.trade.pair is 'Trading pair hash';
COMMENT ON COLUMN oasis.trade.maker is 'Offer creator address';
COMMENT ON COLUMN oasis.trade.taker is 'Trade creator address (msg.sender)';
COMMENT ON COLUMN oasis.trade.lot_gem is 'Lot token address';
COMMENT ON COLUMN oasis.trade.lot_amt is 'Lot amount given by maker';
COMMENT ON COLUMN oasis.trade.bid_gem is 'Bid token address';
COMMENT ON COLUMN oasis.trade.bid_amt is 'Bid amount matched by taker';
COMMENT ON COLUMN oasis.trade.block is 'Block height';
COMMENT ON COLUMN oasis.trade.time is 'Block timestamp';
COMMENT ON COLUMN oasis.trade.tx is 'Transaction hash';

CREATE INDEX oasis_trade_offer_id_index ON oasis.trade(offer_id);
CREATE INDEX oasis_trade_pair_index ON oasis.trade(pair);
CREATE INDEX oasis_trade_lot_gem_index ON oasis.trade(lot_gem);
CREATE INDEX oasis_trade_bid_gem_index ON oasis.trade(bid_gem);
CREATE INDEX oasis_trade_maker_index ON oasis.trade(maker);
CREATE INDEX oasis_trade_taker_index ON oasis.trade(taker);
