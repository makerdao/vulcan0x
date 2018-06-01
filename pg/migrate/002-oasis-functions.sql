ALTER TABLE offer ADD COLUMN killed boolean default false;

CREATE INDEX offer_killed_idx ON offer(killed);
