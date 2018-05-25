CREATE TABLE offer (
  id         integer primary key,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal,
  bid_gem    character varying(66),
  bid_amt    decimal,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) not null
);

CREATE INDEX offer_pair_index ON offer(pair);
CREATE INDEX offer_maker ON offer(maker);

CREATE TABLE trade (
  id         integer,
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

CREATE INDEX trade_id_index ON trade(id);
CREATE INDEX trade_pair_index ON trade(pair);
CREATE INDEX trade_lot_gem_index ON trade(lot_gem);
CREATE INDEX trade_bid_gem_index ON trade(bid_gem);
CREATE INDEX trade_maker_index ON trade(maker);
CREATE INDEX trade_taker_index ON trade(taker);
