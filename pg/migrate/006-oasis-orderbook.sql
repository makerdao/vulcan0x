CREATE VIEW api.oasis_orderbook AS
  SELECT
    id AS offer_id,
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

COMMENT ON COLUMN api.oasis_orderbook.offer_id is 'Offer ID';
COMMENT ON COLUMN api.oasis_orderbook.market is 'Market (BASEQUOTE)';
COMMENT ON COLUMN api.oasis_orderbook.price is 'Price (quote)';
COMMENT ON COLUMN api.oasis_orderbook.amount is 'Amount (base)';
COMMENT ON COLUMN api.oasis_orderbook.act is 'Market action (ask|bid)';
