UPDATE oasis.offer
SET (lot, bid) = (${lot}, ${bid})
WHERE oasis.offers.id = ${id};
