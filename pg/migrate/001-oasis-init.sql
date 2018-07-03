CREATE SCHEMA oasis;

CREATE TABLE oasis.offer (
  id         integer primary key,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal(28,18),
  bid_gem    character varying(66),
  bid_amt    decimal(28,18),
  removed    boolean,
  filled     boolean default false,
  killed     integer default 0,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) not null
);

CREATE INDEX oasis_offer_pair_index ON oasis.offer(pair);
CREATE INDEX oasis_offer_maker_index ON oasis.offer(maker);
CREATE INDEX oasis_offer_killed_index ON oasis.offer(killed);
CREATE INDEX oasis_offer_filled_index ON oasis.offer(filled);
CREATE INDEX oasis_offer_removed_index ON oasis.offer(removed);

CREATE TABLE oasis.trade (
  offer_id   integer,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal(28,18),
  taker      character varying(66),
  bid_gem    character varying(66),
  bid_amt    decimal(28,18),
  removed    boolean,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) not null,
  idx        integer not null,
  CONSTRAINT unique_tx_idx UNIQUE(tx, idx)
);

CREATE INDEX oasis_trade_offer_id_index ON oasis.trade(offer_id);
CREATE INDEX oasis_trade_pair_index ON oasis.trade(pair);
CREATE INDEX oasis_trade_lot_gem_index ON oasis.trade(lot_gem);
CREATE INDEX oasis_trade_bid_gem_index ON oasis.trade(bid_gem);
CREATE INDEX oasis_trade_maker_index ON oasis.trade(maker);
CREATE INDEX oasis_trade_taker_index ON oasis.trade(taker);
CREATE INDEX oasis_trade_removed_index ON oasis.trade(removed);

CREATE TABLE oasis.market (
  id         character varying(10) primary key,
  base       character varying(10),
  quote      character varying(10)
);
