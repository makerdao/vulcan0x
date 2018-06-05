UPDATE oasis.offer
SET killed = ${block}, removed = ${removed}
WHERE id = ${id};
