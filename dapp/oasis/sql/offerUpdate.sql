UPDATE oasis.offer
SET (lot_amt, bid_amt) = (${lot_amt}, ${bid_amt})
WHERE oasis.offer.id = ${id};
