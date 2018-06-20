ALTER TABLE oasis.offer ADD COLUMN filled boolean default false;

CREATE INDEX oasis_offer_filled_index ON oasis.offer(filled);
