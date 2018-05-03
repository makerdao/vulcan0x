UPDATE oasis.offer
SET (lot, bid) = (${event.pay_amt}, ${event.buy_amt})
WHERE oasis.offers.id = ${event.id};
