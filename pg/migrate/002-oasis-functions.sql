CREATE OR REPLACE FUNCTION trade_offer(trade trade) RETURNS offer as $$
  SELECT *
  FROM offer
  WHERE offer.id = trade.id
  LIMIT 1
$$ LANGUAGE SQL stable;
