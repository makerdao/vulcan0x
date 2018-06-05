CREATE FUNCTION oasis.offer_trades(offer oasis.offer) RETURNS setof oasis.trade AS $$
  SELECT *
  FROM oasis.trade
  WHERE oasis.trade.offer_id = offer.id
  ORDER BY oasis.trade.block DESC
$$ LANGUAGE SQL stable;

CREATE FUNCTION oasis.trade_offer(trade oasis.trade) RETURNS oasis.offer AS $$
  SELECT *
  FROM oasis.offer
  WHERE oasis.offer.id = trade.offer_id
  ORDER BY oasis.offer.id DESC
  LIMIT 1
$$ LANGUAGE SQL stable;
