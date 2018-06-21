CREATE TYPE api.oasis_order AS (
  offer      integer,
  market     varchar,
  price      numeric,
  amount     numeric,
  act        varchar
);

COMMENT ON COLUMN api.oasis_order.offer is 'Offer ID';
COMMENT ON COLUMN api.oasis_order.market is 'Market Symbol';
COMMENT ON COLUMN api.oasis_order.price is 'Price (quote)';
COMMENT ON COLUMN api.oasis_order.amount is 'Amount (base)';
COMMENT ON COLUMN api.oasis_order.act is '(ask|bid)';

CREATE FUNCTION api.oasis_orderbook() RETURNS setof api.oasis_order AS $$
  SELECT
    id AS offer,
    market,
    price,
    (
      CASE WHEN act = 'ask' THEN COALESCE(lot_amt - t.lot_total, lot_amt)
      WHEN act = 'bid' THEN COALESCE(bid_amt - t.bid_total, bid_amt)
      ELSE NULL
      END
    ) AS amount,
    act
  FROM api.oasis_offer o
  LEFT JOIN (
      SELECT trade.offer_id,
      SUM(trade.lot_amt) AS lot_total,
      SUM(trade.bid_amt) AS bid_total
      FROM oasis.trade
      GROUP BY 1
  ) t ON t.offer_id = o.id
  WHERE killed = 0
  AND filled = false
  ORDER BY market, act, price;
$$ LANGUAGE SQL stable;
