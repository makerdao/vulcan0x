CREATE FUNCTION api.oasis_offer_trades(offer api.oasis_offer) RETURNS setof api.oasis_trade AS $$
  SELECT *
  FROM api.oasis_trade
  WHERE oasis_trade.offer_id = offer.id
  ORDER BY oasis_trade.block DESC
$$ LANGUAGE SQL stable;

CREATE FUNCTION api.oasis_trade_offer(trade api.oasis_trade) RETURNS api.oasis_offer AS $$
  SELECT *
  FROM api.oasis_offer
  WHERE oasis_offer.id = trade.offer_id
  ORDER BY oasis_offer.id DESC
  LIMIT 1
$$ LANGUAGE SQL stable;
