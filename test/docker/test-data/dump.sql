--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: api; Type: SCHEMA; Schema: -; Owner: vulcan0xadmin
--

CREATE SCHEMA api;


ALTER SCHEMA api OWNER TO vulcan0xadmin;

--
-- Name: oasis; Type: SCHEMA; Schema: -; Owner: vulcan0xadmin
--

CREATE SCHEMA oasis;


ALTER SCHEMA oasis OWNER TO vulcan0xadmin;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: offer; Type: TABLE; Schema: oasis; Owner: vulcan0xadmin
--

CREATE TABLE oasis.offer (
    id integer NOT NULL,
    pair character varying(66),
    maker character varying(66),
    lot_gem character varying(66),
    lot_amt numeric(28,18),
    bid_gem character varying(66),
    bid_amt numeric(28,18),
    removed boolean,
    killed integer DEFAULT 0,
    block integer NOT NULL,
    "time" timestamp with time zone NOT NULL,
    tx character varying(66) NOT NULL
);


ALTER TABLE oasis.offer OWNER TO vulcan0xadmin;

--
-- Name: token; Type: TABLE; Schema: oasis; Owner: vulcan0xadmin
--

CREATE TABLE oasis.token (
    address character varying(66) NOT NULL,
    symbol character varying(5) NOT NULL,
    name character varying(66)
);


ALTER TABLE oasis.token OWNER TO vulcan0xadmin;

--
-- Name: oasis_offer; Type: VIEW; Schema: api; Owner: vulcan0xadmin
--

CREATE VIEW api.oasis_offer AS
 SELECT o.id,
    o.pair AS pair_hash,
    ( SELECT concat(lot.symbol, '/', bid.symbol) AS concat) AS pair,
    o.maker,
    o.lot_gem,
    lot.symbol AS lot_tkn,
    o.lot_amt,
    o.bid_gem,
    bid.symbol AS bid_tkn,
    o.bid_amt,
    o.killed,
    o.block,
    o."time",
    o.tx
   FROM ((oasis.offer o
     LEFT JOIN oasis.token lot ON (((lot.address)::text = (o.lot_gem)::text)))
     LEFT JOIN oasis.token bid ON (((bid.address)::text = (o.bid_gem)::text)));


ALTER TABLE api.oasis_offer OWNER TO vulcan0xadmin;

--
-- Name: COLUMN oasis_offer.id; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.id IS 'Unique offer identifier';


--
-- Name: COLUMN oasis_offer.pair_hash; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.pair_hash IS 'Trading pair hash';


--
-- Name: COLUMN oasis_offer.pair; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.pair IS 'Trading pair';


--
-- Name: COLUMN oasis_offer.maker; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.maker IS 'Offer creator address (msg.sender)';


--
-- Name: COLUMN oasis_offer.lot_gem; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.lot_gem IS 'Lot token address';


--
-- Name: COLUMN oasis_offer.lot_tkn; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.lot_tkn IS 'Lot token symbol';


--
-- Name: COLUMN oasis_offer.lot_amt; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.lot_amt IS 'Lot amount given';


--
-- Name: COLUMN oasis_offer.bid_gem; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.bid_gem IS 'Bid token address';


--
-- Name: COLUMN oasis_offer.bid_tkn; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.bid_tkn IS 'Bid token symbol';


--
-- Name: COLUMN oasis_offer.bid_amt; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.bid_amt IS 'Bid amount wanted';


--
-- Name: COLUMN oasis_offer.killed; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.killed IS '0 if the offer is live or block height when killed';


--
-- Name: COLUMN oasis_offer.block; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.block IS 'Block height';


--
-- Name: COLUMN oasis_offer."time"; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer."time" IS 'Block timestamp';


--
-- Name: COLUMN oasis_offer.tx; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_offer.tx IS 'Transaction hash';


--
-- Name: trade; Type: TABLE; Schema: oasis; Owner: vulcan0xadmin
--

CREATE TABLE oasis.trade (
    offer_id integer,
    pair character varying(66),
    maker character varying(66),
    lot_gem character varying(66),
    lot_amt numeric(28,18),
    taker character varying(66),
    bid_gem character varying(66),
    bid_amt numeric(28,18),
    removed boolean,
    block integer NOT NULL,
    "time" timestamp with time zone NOT NULL,
    tx character varying(66) NOT NULL
);


ALTER TABLE oasis.trade OWNER TO vulcan0xadmin;

--
-- Name: oasis_trade; Type: VIEW; Schema: api; Owner: vulcan0xadmin
--

CREATE VIEW api.oasis_trade AS
 SELECT t.offer_id,
    t.pair AS pair_hash,
    ( SELECT concat(lot.symbol, '/', bid.symbol) AS concat) AS pair,
    t.maker,
    t.taker,
    t.lot_gem,
    lot.symbol AS lot_tkn,
    t.lot_amt,
    t.bid_gem,
    bid.symbol AS bid_tkn,
    t.bid_amt,
    t.block,
    t."time",
    t.tx
   FROM ((oasis.trade t
     LEFT JOIN oasis.token lot ON (((lot.address)::text = (t.lot_gem)::text)))
     LEFT JOIN oasis.token bid ON (((bid.address)::text = (t.bid_gem)::text)));


ALTER TABLE api.oasis_trade OWNER TO vulcan0xadmin;

--
-- Name: COLUMN oasis_trade.offer_id; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.offer_id IS 'Offer identifier';


--
-- Name: COLUMN oasis_trade.pair_hash; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.pair_hash IS 'Trading pair hash';


--
-- Name: COLUMN oasis_trade.pair; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.pair IS 'Trading pair';


--
-- Name: COLUMN oasis_trade.maker; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.maker IS 'Offer creator address';


--
-- Name: COLUMN oasis_trade.taker; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.taker IS 'Trade creator address (msg.sender)';


--
-- Name: COLUMN oasis_trade.lot_gem; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.lot_gem IS 'Lot token address';


--
-- Name: COLUMN oasis_trade.lot_tkn; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.lot_tkn IS 'Lot token symbol';


--
-- Name: COLUMN oasis_trade.lot_amt; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.lot_amt IS 'Lot amount given by maker';


--
-- Name: COLUMN oasis_trade.bid_gem; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.bid_gem IS 'Bid token address';


--
-- Name: COLUMN oasis_trade.bid_tkn; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.bid_tkn IS 'Bid token symbol';


--
-- Name: COLUMN oasis_trade.bid_amt; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.bid_amt IS 'Bid amount matched by taker';


--
-- Name: COLUMN oasis_trade.block; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.block IS 'Block height';


--
-- Name: COLUMN oasis_trade."time"; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade."time" IS 'Block timestamp';


--
-- Name: COLUMN oasis_trade.tx; Type: COMMENT; Schema: api; Owner: vulcan0xadmin
--

COMMENT ON COLUMN api.oasis_trade.tx IS 'Transaction hash';


--
-- Name: oasis_offer_trades(api.oasis_offer); Type: FUNCTION; Schema: api; Owner: vulcan0xadmin
--

CREATE FUNCTION api.oasis_offer_trades(offer api.oasis_offer) RETURNS SETOF api.oasis_trade
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM api.oasis_trade
  WHERE oasis_trade.offer_id = offer.id
  ORDER BY oasis_trade.block DESC
$$;


ALTER FUNCTION api.oasis_offer_trades(offer api.oasis_offer) OWNER TO vulcan0xadmin;

--
-- Name: oasis_trade_offer(api.oasis_trade); Type: FUNCTION; Schema: api; Owner: vulcan0xadmin
--

CREATE FUNCTION api.oasis_trade_offer(trade api.oasis_trade) RETURNS api.oasis_offer
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM api.oasis_offer
  WHERE oasis_offer.id = trade.offer_id
  ORDER BY oasis_offer.id DESC
  LIMIT 1
$$;


ALTER FUNCTION api.oasis_trade_offer(trade api.oasis_trade) OWNER TO vulcan0xadmin;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: vulcan0xadmin
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.migrations OWNER TO vulcan0xadmin;

--
-- Data for Name: offer; Type: TABLE DATA; Schema: oasis; Owner: vulcan0xadmin
--

INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (844, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 5.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2120.000000000000000000, NULL, 0, 7637891, '2018-06-11 18:44:20+00', '0x28bf8988a45e671ad596641c9707e73dfaf65c56e8bbd9d22c79e5c39136c181');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (838, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x37ecF0EE1FC3dcc847715ea226221652528Bd26C', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.650000000000000000, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.500000000000000000, NULL, 0, 7614991, '2018-06-09 02:21:32+00', '0x0dfb18c9d94237b2096400da93baa2edc752a3f21470a978e625785287c26cb0');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (845, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1.000000000000000000, '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 1111.000000000000000000, NULL, 0, 7638057, '2018-06-11 19:10:44+00', '0xae2d04e0a57c482ad6a1a531fd05b5289e2c26488410fab3923d243265974bdf');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (846, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 111.000000000000000000, NULL, 0, 7638137, '2018-06-11 19:23:56+00', '0x006bbbd62d52605ea0a9c671bff366328a9e0fe3ccaeae7bac4129bbc9089e52');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (839, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x37ecF0EE1FC3dcc847715ea226221652528Bd26C', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.600000000000000000, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 3.000000000000000000, NULL, 0, 7615000, '2018-06-09 02:23:20+00', '0x003b5a0fc475c006aa7ce3ab09c01ac51290ef9608e9fcfcbc325b071f497035');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (842, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0x14149190Ec6F59b5BcF41C83c328367Ef859eAd1', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 64.500000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.100000000000000000, NULL, 0, 7635868, '2018-06-11 13:24:12+00', '0x3209aa1ed540f399c1869d00c6a4d3247fe68531f42b3c1c09206a85388b8102');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (847, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 11.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 121.000000000000000000, NULL, 0, 7638193, '2018-06-11 19:32:44+00', '0x9495fdecf584f392fa99fa847cba5098d63e846c1d7bb23062b6af266a7b9c1f');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (843, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 11.000000000000000000, NULL, 7637845, 7637765, '2018-06-11 18:24:48+00', '0x7ec4fe243cf93a496cf5975cd9c422c3637296baa0d67d433cf49046ebbea6da');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (841, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0x14149190Ec6F59b5BcF41C83c328367Ef859eAd1', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 64.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.100000000000000000, NULL, 7635855, 7635831, '2018-06-11 13:17:56+00', '0xe10394e590d28b64d5b8966bb87623b1606aca94fa0d73d6bc3bb7df7fb2696e');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (840, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 2.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2.000000000000000000, NULL, 0, 7634567, '2018-06-11 10:02:36+00', '0x8df9ee9d0d8ab885eb90e00c93dca6396e84802fbc7238a27010764a9b9770d6');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (834, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1.000000000000000000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 21.000000000000000000, NULL, 0, 7610783, '2018-06-08 11:23:08+00', '0x1fe63b5f3d55f791dc8325cbbc8a54ad0e3d97b512ef9aad217884708d01885b');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (837, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x37ecF0EE1FC3dcc847715ea226221652528Bd26C', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2.471003625000000000, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 4.942007250000000000, NULL, 0, 7613751, '2018-06-08 21:47:40+00', '0x013e4200ae63be6b72d42f20bb584939466a0567114e4dcf4653c47cc7006a3c');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (835, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xFCe1baE0F16c07377DbB680fcD0aA94b011EB7aF', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.010000000000000000, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.010000000000000000, NULL, 0, 7610909, '2018-06-08 11:48:32+00', '0x35dca2025a65c7c4b9a30a9e48bf17430e8b16838414337cb7e2eecfae6d3f1b');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (836, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xFCe1baE0F16c07377DbB680fcD0aA94b011EB7aF', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.010000000000000000, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.010000000000000000, NULL, 0, 7610959, '2018-06-08 11:58:32+00', '0x88d73a4cd1f34d58c1682da4e93574518cb426ddfacfa21e8f2c54d3f244c0c5');


--
-- Data for Name: token; Type: TABLE DATA; Schema: oasis; Owner: vulcan0xadmin
--

INSERT INTO oasis.token (address, symbol, name) VALUES ('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2', 'WETH', 'Wrapped ETH');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359', 'DAI', 'Dai Stablecoin');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x59aDCF176ED2f6788A41B8eA4c4904518e62B6A4', 'SAI', 'Sai Stablecoin');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2', 'MKR', 'Maker');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0xBEB9eF514a379B997e0798FDcC901Ee474B6D9A1', 'MLN', 'Melonport');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0xAf30D2a7E90d7DC361c8C4585e9BB7D2F6f15bc7', 'ST', 'FirstBlood');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A', 'DGD', 'DigixDAO');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0xE94327D07Fc17907b4DB788E5aDf2ed424adDff6', 'REP', 'Augur');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x168296bb09e24A88805CB9c33356536B980D3fC5', 'RHOC', 'RChain');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x888666CA69E0f178DED6D75b5726Cee99A87D698', 'ICN', 'Iconomi');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x01AfC37F4F85babc47c0E2d0EAbABC7FB49793c8', 'W-GNT', 'Golem');
INSERT INTO oasis.token (address, symbol, name) VALUES ('0x0D8775F648430679A709E98d2b0Cb6250d2887EF', 'BAT', 'Brave');


--
-- Data for Name: trade; Type: TABLE DATA; Schema: oasis; Owner: vulcan0xadmin
--

INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000001443001443001, '0x2014B9e98db2A0a587a10291b5E87bcbC3028Cd6', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000999999999999693, NULL, 7647583, '2018-06-12 20:12:48+00', '0x1f6f4242700356bb8f19f3adfa57ef25c8918dfda8690048aafb90375b7afb41');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647626, '2018-06-12 20:19:44+00', '0xeaf9b5413319797eb71cce4cd1da054bb05727e045a41911a9d062d7057b6cda');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647618, '2018-06-12 20:18:32+00', '0x2441483738726ff45b009e86edb6f81e7e6b8faebf8c37bcb6496bba4b86bf2f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647569, '2018-06-12 20:10:24+00', '0x577f1c986fd121428e43c28feef7db950c281190df65f64e79c0ff5710071d21');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647641, '2018-06-12 20:22:08+00', '0x8f04916d1517c5e3ea5dc00b52a89cf0c4821153c3901de0d1bedf69f07e4ef5');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647646, '2018-06-12 20:23:00+00', '0x33681dc4b82f9660c93abfe0789eaeccd52e40c435ad70e0404c485ede2e9599');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647657, '2018-06-12 20:24:48+00', '0xd8e3fdecf39d3499a990b1a35571bc630172a4f884c40e4bec95fcca6ee2c171');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647476, '2018-06-12 19:55:32+00', '0x64914af7603cf6464275172aba394802a4fead47eb3107dc0385d391b3c26e74');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647665, '2018-06-12 20:26:04+00', '0x9eb3062522a288569532e7010a35f3bbbbfda08b512d28992e168392bcdeceac');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.579000000000000000, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000999999999999999, NULL, 7647671, '2018-06-12 20:27:12+00', '0xd414add9f78f0adadb75cac006a45f87d16e54dee34949109d151036b4dfecb3');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.579000000000000000, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000999999999999999, NULL, 7647748, '2018-06-12 20:38:56+00', '0xc3161c1ba58fb0157157e5d472f4b86e6ebe92e63989be93dbd740e617d3b8ea');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647767, '2018-06-12 20:41:56+00', '0x6cc0a672d7a36bb258cd24d2671ca0f17efeee9f597eb87d1ccca84b97231c9e');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000001443001443001, '0x09182538cCbEf1b6523AFF0f75285d488c60BE74', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000999999999999693, NULL, 7647771, '2018-06-12 20:42:32+00', '0x2b4622b337c6befae3d1ff402cbfe4a530b19990ee530705243745f45c402c09');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647803, '2018-06-12 20:47:20+00', '0x5e8f5fbafc6d5267fd261ceb10fcb7d39bf6d1a50a46cc0d7cd197653ecbd897');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 1291.678182375402000000, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2.230877689767533800, NULL, 7645067, '2018-06-12 13:34:24+00', '0xb348cd354a30580d767ebf05b042b21a393155003fb02bf30de62506ac5cad61');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.014430014430014430, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 10.000000000000000000, NULL, 7641262, '2018-06-12 03:42:52+00', '0xff865b2db7092b21db069c06829a3c1178e793341a71b8283059510121eb599f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (842, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0x14149190Ec6F59b5BcF41C83c328367Ef859eAd1', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 64.500000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.100000000000000000, NULL, 7636689, '2018-06-11 15:33:12+00', '0x81ed47fc67ebc4897e84af17325f27415aa0af550a7ba5e3390fee33a7640672');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.043290043290043290, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 30.000000000000000000, NULL, 7634280, '2018-06-11 09:17:20+00', '0x9cb47e3872b300efb9a754164a049d5f82d87666b2134e59389411ee56f4aad0');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647784, '2018-06-12 20:44:36+00', '0x07d684b6656d59992318ff6fad7c028367cc5d4699b9ace114484a56f3540d85');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.047619047619047616, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 33.000000000000000000, NULL, 7642134, '2018-06-12 06:00:48+00', '0x82da3333381cca889194be2d74079e215437e9277406c43103fc21813cb0393d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.630000000000000000, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.001000000000000000, NULL, 7635096, '2018-06-11 11:24:16+00', '0xece913a59c49e604078024cd17889ab6216d49c3eaf86cd9e562cc33ef80e3c0');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.630000000000000000, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.001000000000000000, NULL, 7633985, '2018-06-11 08:32:04+00', '0x9eb1fb70ce0529c1c75629a6cc69d5cab9a79a224662638615626f69101918d2');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (810, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x0cb27e883E207905AD2A94F9B6eF0C7A99223C37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.033805848253795255, '0x86944F4Dd808005197907bf9547129e997F745C6', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 23.326035295118725000, NULL, 7619640, '2018-06-09 17:45:48+00', '0xdf05a67daacf991acd2dab0681490efb16915b6b904b08045095f576cf02b1bb');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xe6D3ea40592Ee8ddab6f0C99F846619029349419', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647808, '2018-06-12 20:48:12+00', '0x1ace3d9b6a50fb3025fe081c3f7053ccb7dfcbe47db6f1b0f88c7a58e8d4585d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 579.000000000000000000, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1.000000000000000000, NULL, 7645086, '2018-06-12 13:37:24+00', '0xbd13636e6bb00cff58c5eba06d331cce9a2b50a8af655a3da8a01897e2997696');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.004329004329004329, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 3.000000000000000000, NULL, 7641268, '2018-06-12 03:43:44+00', '0x8dd679beca9cd8ec261a064ce61d01995d9ee22d204510dce31fb87dedb5c31a');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (729, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 8.966059772814999000, '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 7.471716477345832000, NULL, 7638171, '2018-06-11 19:29:20+00', '0xa757bbe82d19a7f15180ffcb0e5a939db28c51ed5b1998f74c167c48f5673085');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.630000000000000000, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.001000000000000000, NULL, 7633951, '2018-06-11 08:26:40+00', '0x4a35f841d1a96816fb987ad576353e6e779e3a3566cfb4b0920b79b7440cc980');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7631990, '2018-06-11 03:14:56+00', '0x9e0da604d4d8605c692dfb59472c2e6d886dc120eb9bfd4dffa29b5442cf987f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0xe6D3ea40592Ee8ddab6f0C99F846619029349419', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647814, '2018-06-12 20:48:56+00', '0xe245a7e64def0714df7b72eefcf94bfb173301b2a0440856b53ff7e15a912704');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.432900432900432900, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 300.000000000000000000, NULL, 7645097, '2018-06-12 13:38:56+00', '0xde0d49a4907b076bc1e5b4b5de0924f9cda52e3732883a585f0b7888b67d36aa');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.037518037518037520, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 26.000000000000000000, NULL, 7640536, '2018-06-12 01:51:20+00', '0x2e4379bf4155952a5ffa6b5c2e19d00abdfd1693c3dd130994263a2ae45b1930');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (810, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x0cb27e883E207905AD2A94F9B6eF0C7A99223C37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018840579710144930, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7631761, '2018-06-11 02:39:56+00', '0xc0f01900fccd40c494a67896f87559981a301b8f152a6af530de080348b02820');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0xe6D3ea40592Ee8ddab6f0C99F846619029349419', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647818, '2018-06-12 20:49:32+00', '0x274261c6e542753d870d57c64e29de801ea13be6927dfe96524c2c7d8733bf28');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.432900432900432900, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 300.000000000000000000, NULL, 7645103, '2018-06-12 13:39:52+00', '0xc0898edf37d483161360f21f97fdca57506ae414dbdcbc07925a5f5f5ac40b8b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.014430014430014430, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 10.000000000000000000, NULL, 7640541, '2018-06-12 01:52:08+00', '0x4db24b819a3bb531e130ae6eaa65f96f7577b3420917d75b0017a4ec7d30706d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 94.500000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.150000000000000000, NULL, 7636725, '2018-06-11 15:38:40+00', '0xae63857fe6a7834d23a0f6ce1795ad8e74e3b4cbed993b68896f88ac6dc62af9');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (810, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x0cb27e883E207905AD2A94F9B6eF0C7A99223C37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018840579710144930, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7631796, '2018-06-11 02:45:32+00', '0x3749c90ddc6dde4d1951bb29e3d9e8d14d8e09ae4a47ecdcdc192e782de9a24f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000028860028860028, '0xD449D4f256F4e75a5d16F233E4b6A77079C4B736', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.019999999999999404, NULL, 7647845, '2018-06-12 20:54:12+00', '0x8b1915534f3f4771acc1a55f18e402e6acb392bcaa53b7fdc16db437ed8c812f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.037518037518037520, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 26.000000000000000000, NULL, 7645402, '2018-06-12 14:26:08+00', '0x738024811dbfafde48657b05658c8a893e43c024e1b084d4b8244ea38a2ace5b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.004329004329004329, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 3.000000000000000000, NULL, 7640546, '2018-06-12 01:53:00+00', '0x9f760085a7aa166fb0141e7e23be429986485b4c5b904917230e4727e6e8b28e');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 111.000000000000000000, '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.176190476190476200, NULL, 7637672, '2018-06-11 18:09:56+00', '0x487444f899ec4f0f6eaee8fe8e00a46d9e95e520fb5e6c67056deefe4af1aef8');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (810, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x0cb27e883E207905AD2A94F9B6eF0C7A99223C37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.006330516401452893, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 4.368056317002496000, NULL, 7631821, '2018-06-11 02:49:24+00', '0x2d0c67c2c4f5553f1dfa9517266a6cc5d8e31c0f4ab3775549a6208409875d27');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xD449D4f256F4e75a5d16F233E4b6A77079C4B736', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647944, '2018-06-12 21:09:32+00', '0x2ca70a229074f120d4179d5b97c03b70a846a5aaa039be0a494179864cc1a02d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.014430014430014430, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 10.000000000000000000, NULL, 7645715, '2018-06-12 15:15:48+00', '0x00d4c2e7017754e2fc92824d44eca4da4f8f7fefe0cc7c9fbb3947b1f04b19b2');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 24.000000000000000000, '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.038095238095238090, NULL, 7637712, '2018-06-11 18:16:08+00', '0xcfb4a2b7373f31327eeb6b748c976c6bdcfd91441aa16b49440698d43cb6fea8');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7632908, '2018-06-11 05:42:12+00', '0x1ad03d192577e4ab7227be3283e1efa8379e861911f9501d7f90c38a3d092247');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7631841, '2018-06-11 02:52:24+00', '0x82bd83af528c3ec237a7efecfd610142d95ae037145de4a1434a4b6cb7c1345a');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (793, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 2375.048376026355000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 3.518590186705711000, NULL, 7616941, '2018-06-09 09:45:52+00', '0x1b65430b878b156662746945a2433aa7a636828391ec87925cd19a58ff20fd52');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647958, '2018-06-12 21:11:56+00', '0xbc3b36315435c651a7d3ad2635691b3896be9c6ddb6d62bd2876e16ccfbf8bb7');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.004329004329004329, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 3.000000000000000000, NULL, 7645721, '2018-06-12 15:16:32+00', '0xb36254bf4d9c736a9420ac31d511c725cbd09cebe1af1d5ded1f17b332de0175');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 36.000000000000000000, '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.057142857142857140, NULL, 7638047, '2018-06-11 19:09:12+00', '0x46ec0cfeb907f61f551c06e31b01820e927d09e98bc2b06ab1aa77a174d43aa3');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7632922, '2018-06-11 05:44:08+00', '0xe5ee59d32fda7f7d4b8f2f3044bec61f83e4f24bd7513bd7dbedf34186afeb25');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7631872, '2018-06-11 02:56:56+00', '0xfd283adfb14a4c0e36ea108f161df0ffd3163e83e0169347cb0ec3f190234c0c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0xD449D4f256F4e75a5d16F233E4b6A77079C4B736', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647906, '2018-06-12 21:03:48+00', '0x6d8417cd101574cc0a6ff90fdbd938503bd940866a95bcb36d37a6d00718cc65');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.037518037518037520, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 26.000000000000000000, NULL, 7645710, '2018-06-12 15:14:56+00', '0x27c16125523cf7c9d759eddc7b15e06a3fdf279c1efd2e83b661cfd4167e489b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (795, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 123.000000000000000000, '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.195238095238095240, NULL, 7637684, '2018-06-11 18:11:56+00', '0x2077620bc297a1a77b19d763c080bfe0d977e47e5f997cfa4214f1e30c1a807a');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7632808, '2018-06-11 05:25:44+00', '0x0ec3eb4e6d2f751783c8abc3c3caf98e003da7be68b1580dad33014bea57adca');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (826, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5639637F5530b91Ad88B5b7264CE928144F8AFdE', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.001000000000000000, '0xFCe1baE0F16c07377DbB680fcD0aA94b011EB7aF', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.001600000000000000, NULL, 7610973, '2018-06-08 12:01:28+00', '0x9ce6b20f788439796557149694a8bd1caebb55adfc9350db30b268250a3505c6');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647379, '2018-06-12 19:40:44+00', '0xb08eb5f97fd401ed3d5a8c0d4267020ef39d6713a4a5180e8045b7fc66c1f1fa');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647451, '2018-06-12 19:51:48+00', '0x36bf5b8c44ee5c3dc3f3dc15fb9f2d187761c0e7deedba9ba057d6a611b5b382');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647415, '2018-06-12 19:46:24+00', '0xb8df585ed05c225f1f2aad578b1c1aaf9036c5d6bc7589c10519ba2bef0b17b6');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5.790000000000000000, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999998, NULL, 7647411, '2018-06-12 19:45:48+00', '0x3ada06a474e565c6a2d42c83f3a7ddd811c8aed7801a1424d8ed8b4e6c79fae3');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (796, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 579.000000000000000000, '0x102b556D0c5f93d056F0fE00DaB8D7DA54942026', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1.000000000000000000, NULL, 7646746, '2018-06-12 18:00:12+00', '0x868940019403cbcc881f3912abe8f81a82265b849621caa98b985d4e9a544e93');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647423, '2018-06-12 19:47:36+00', '0xaf9f0f400714f7002c38fd064c78140b56f4f701ce1c54ae2ea3407dfbaf9d52');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000001443001443001, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000999999999999693, NULL, 7647463, '2018-06-12 19:53:40+00', '0x69cc5da2bc58459221775ba68ca63f022b4e9dc151c82fbf966ed3ea19c347aa');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000014430014430014, '0x9331D344B467fbe6fF432818B02C557ff59d01c0', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.009999999999999702, NULL, 7647388, '2018-06-12 19:42:12+00', '0x6df4718932cb40910a98b675a835ea81f247db2a7ea4b27ccf0d802ce75f01a4');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.014430014430014430, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 10.000000000000000000, NULL, 7645053, '2018-06-12 13:32:04+00', '0xd7077f679834a545c9eb608ee5d5fe24a3bbedb3eac964998187a4bb3e087ef1');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.037518037518037520, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 26.000000000000000000, NULL, 7641257, '2018-06-12 03:42:12+00', '0x8616860d799d87720a42566a214270c72919499b93a41c0fc077cea93cf1ad7c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (838, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x37ecF0EE1FC3dcc847715ea226221652528Bd26C', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.650000000000000000, '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.500000000000000000, NULL, 7638164, '2018-06-11 19:28:24+00', '0x970b630438f1d0ff5e30e1a0f6e6f97474ac62bb2f670df8627838e4e3045d20');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7632951, '2018-06-11 05:48:48+00', '0xa5f574fe40058cdf3214db20ba308eab28e58b7848bbee6113a080d4596e4f8e');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (801, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.018759018759018760, '0x40502eaa3FCFD60Ef97162A8b2246995E42dBeAC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 13.000000000000000000, NULL, 7631944, '2018-06-11 03:08:00+00', '0x4a8cc1d7ebe91459d1d3ba4f2c88db08839fe448ea5a7718c4a402de8103f9c6');


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: vulcan0xadmin
--

INSERT INTO public.migrations (id, name, hash, executed_at) VALUES (0, 'create-migrations-table', 'e18db593bcde2aca2a408c4d1100f6abba2195df', '2018-06-13 05:09:45.202247');


--
-- Name: offer offer_pkey; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.offer
    ADD CONSTRAINT offer_pkey PRIMARY KEY (id);


--
-- Name: token token_address_key; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.token
    ADD CONSTRAINT token_address_key UNIQUE (address);


--
-- Name: token token_symbol_key; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.token
    ADD CONSTRAINT token_symbol_key UNIQUE (symbol);


--
-- Name: trade trade_tx_key; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.trade
    ADD CONSTRAINT trade_tx_key UNIQUE (tx);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: public; Owner: vulcan0xadmin
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: vulcan0xadmin
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: oasis_offer_killed_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_offer_killed_index ON oasis.offer USING btree (killed);


--
-- Name: oasis_offer_maker_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_offer_maker_index ON oasis.offer USING btree (maker);


--
-- Name: oasis_offer_pair_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_offer_pair_index ON oasis.offer USING btree (pair);


--
-- Name: oasis_offer_removed_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_offer_removed_index ON oasis.offer USING btree (removed);


--
-- Name: oasis_trade_bid_gem_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_bid_gem_index ON oasis.trade USING btree (bid_gem);


--
-- Name: oasis_trade_lot_gem_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_lot_gem_index ON oasis.trade USING btree (lot_gem);


--
-- Name: oasis_trade_maker_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_maker_index ON oasis.trade USING btree (maker);


--
-- Name: oasis_trade_offer_id_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_offer_id_index ON oasis.trade USING btree (offer_id);


--
-- Name: oasis_trade_pair_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_pair_index ON oasis.trade USING btree (pair);


--
-- Name: oasis_trade_removed_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_removed_index ON oasis.trade USING btree (removed);


--
-- Name: oasis_trade_taker_index; Type: INDEX; Schema: oasis; Owner: vulcan0xadmin
--

CREATE INDEX oasis_trade_taker_index ON oasis.trade USING btree (taker);


--
-- PostgreSQL database dump complete
--
