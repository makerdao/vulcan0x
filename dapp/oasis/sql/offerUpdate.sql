UPDATE oasis.offer
SET filled = ${filled}
WHERE id = ${id} AND filled != true;
