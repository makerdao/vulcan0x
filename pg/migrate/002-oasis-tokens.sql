CREATE TABLE oasis.token (
  address     character varying(66) unique not null,
  symbol      character varying(5) unique not null,
  name        character varying(66)
);

INSERT INTO oasis.token VALUES
  ( '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', 'WETH', 'Wrapped ETH' ),
  ( '0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359', 'DAI', 'Dai Stablecoin' ),
  ( '0x59aDCF176ED2f6788A41B8eA4c4904518e62B6A4', 'SAI', 'Sai Stablecoin' ),
  ( '0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2', 'MKR', 'Maker' ),
  ( '0xBEB9eF514a379B997e0798FDcC901Ee474B6D9A1', 'MLN', 'Melonport' ),
  ( '0xAf30D2a7E90d7DC361c8C4585e9BB7D2F6f15bc7', 'ST', 'FirstBlood' ),
  ( '0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A', 'DGD', 'DigixDAO' ),
  ( '0xE94327D07Fc17907b4DB788E5aDf2ed424adDff6', 'REP', 'Augur' ),
  ( '0x168296bb09e24A88805CB9c33356536B980D3fC5', 'RHOC', 'RChain' ),
  ( '0x888666CA69E0f178DED6D75b5726Cee99A87D698', 'ICN', 'Iconomi' ),
  ( '0x01AfC37F4F85babc47c0E2d0EAbABC7FB49793c8', 'W-GNT', 'Golem' ),
  ( '0x0D8775F648430679A709E98d2b0Cb6250d2887EF', 'BAT', 'Brave');
