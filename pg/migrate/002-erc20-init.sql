CREATE SCHEMA erc20;

CREATE TABLE erc20.token (
  key      character varying(66) unique not null,
  symbol   character varying(5) unique not null,
  decimals integer,
  chain    character varying(10),
  name     character varying(66)
);

CREATE INDEX erc20_token_chain_index ON erc20.token(chain);

CREATE TABLE erc20.transfer (
  gem   character varying(66),
  src   character varying(66),
  dst   character varying(66),
  amt   decimal(28,18),
  block integer not null,
  time  timestamptz not null,
  tx    character varying(66) unique not null
);

CREATE INDEX erc20_transfer_src_idx ON erc20.transfer(src);
CREATE INDEX erc20_transfer_dst_idx ON erc20.transfer(dst);

CREATE TABLE erc20.balance (
  gem   character varying(66),
  lad   character varying(66),
  amt   decimal(28,18),
  code  boolean,
  block integer not null,
  time  timestamptz not null,
  tx    character varying(66) not null,

  CONSTRAINT unique_gem_lad UNIQUE (gem,lad)
);

CREATE INDEX erc20_balance_gem_idx ON erc20.balance(gem);
CREATE INDEX erc20_balance_lad_idx ON erc20.balance(lad);
CREATE INDEX erc20_balance_code_idx ON erc20.balance(code);
