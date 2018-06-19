CREATE TYPE api.oasis_market AS (
  pair     varchar,
  lot_gem  varchar,
  bid_gem  varchar,
  vol      numeric,
  price    numeric,
  low      numeric,
  high     numeric
);

CREATE FUNCTION api.oasis_markets(period text DEFAULT '24 hours')
RETURNS SETOF api.oasis_market
AS
$$
  SELECT
    pair,
    lot_gem,
    bid_gem,
    SUM(lot_amt) as vol,
    SUM(price*bid_amt)/SUM(bid_amt) as price,
    MIN(price) AS low,
    MAX(price) AS high
  FROM api.oasis_trade
  WHERE time > now() - $1::interval
  GROUP BY pair, lot_gem, bid_gem;
$$ LANGUAGE SQL stable;
