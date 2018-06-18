CREATE SCHEMA erc20;

CREATE TABLE erc20.token (
  key      character varying(66) unique not null,
  symbol   character varying(5) unique not null,
  decimals integer,
  chain    character varying(10),
  name     character varying(66)
);

CREATE INDEX erc20_token_chain_index ON erc20.token(chain);
