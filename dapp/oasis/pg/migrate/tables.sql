CREATE TABLE oasis.offer (
  id         integer primary key,
  pair       character varying(66),
  gem        character varying(66),
  lot        decimal,
  pie        character varying(66),
  bid        decimal,
  guy        character varying(66),
  block      integer not null,
  time       timestampz not null,
  tx         character varying(66) not null
);

CREATE INDEX offer_pair_index ON oasis.offer(pair);
CREATE INDEX offer_guy_index ON oasis.offer(guy);

CREATE TABLE oasis.trade (
  id         integer,
  pair       character varying(66),
  guy        character varying(66),
  gem        character varying(66),
  lot        decimal,
  gal        character varying(66),
  pie        character varying(66),
  bid        decimal,
  block      integer not null,
  time       timestampz not null,
  tx         character varying(66) not null
);

CREATE INDEX trade_id_index ON oasis.trade(id);
CREATE INDEX trade_pair_index ON oasis.trade(pair);
CREATE INDEX trade_gem_index ON oasis.trade(gem);
CREATE INDEX trade_pie_index ON oasis.trade(pie);
CREATE INDEX trade_guy_index ON oasis.trade(guy);
CREATE INDEX trade_gal_index ON oasis.trade(gal);
