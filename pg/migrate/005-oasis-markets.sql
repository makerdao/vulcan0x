CREATE TYPE api.oasis_market AS (
  id         varchar,
  base       varchar,
  quote      varchar,
  buy_vol    numeric,
  sell_vol   numeric,
  price      numeric,
  high       numeric,
  low        numeric
);

COMMENT ON COLUMN api.oasis_market.id is 'Unique market symbol';
COMMENT ON COLUMN api.oasis_market.base is 'Base symbol';
COMMENT ON COLUMN api.oasis_market.quote is 'Quote symbol';
COMMENT ON COLUMN api.oasis_market.buy_vol is 'Total buy volume (base)';
COMMENT ON COLUMN api.oasis_market.sell_vol is 'Total sell volume (base)';
COMMENT ON COLUMN api.oasis_market.price is 'Volume weighted average sell price (quote)';
COMMENT ON COLUMN api.oasis_market.high is 'Max sell price';
COMMENT ON COLUMN api.oasis_market.low is 'Min buy price';

CREATE FUNCTION api.oasis_markets(period text DEFAULT '24 hours')
RETURNS SETOF api.oasis_market
AS
$$
  SELECT
    id,
    base,
    quote,
    buys.vol,
    sells.vol,
    (sells.price+buys.price) / 2,
    sells.high,
    buys.low
  FROM oasis.market m
  LEFT JOIN (
    SELECT
      lot_tkn,
      bid_tkn,
      SUM(lot_amt) as vol,
      SUM(price*bid_amt)/SUM(bid_amt) as price,
      MIN(price) AS low,
      MAX(price) AS high
    FROM api.oasis_trade
    WHERE time > now() - $1::interval
    GROUP BY lot_tkn, bid_tkn
  ) sells ON sells.lot_tkn = m.base AND sells.bid_tkn = m.quote
  LEFT JOIN (
    SELECT
      lot_tkn,
      bid_tkn,
      SUM(bid_amt) as vol,
      SUM(price*bid_amt)/SUM(bid_amt) as price,
      MIN(price) AS low,
      MAX(price) AS high
    FROM api.oasis_trade
    WHERE time > now() - $1::interval
    GROUP BY lot_tkn, bid_tkn
  ) buys ON buys.bid_tkn = m.base AND buys.lot_tkn = m.quote;
$$ LANGUAGE SQL stable;
