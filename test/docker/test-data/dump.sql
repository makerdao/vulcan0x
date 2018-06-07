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
    lot_amt numeric,
    bid_gem character varying(66),
    bid_amt numeric,
    removed boolean,
    killed integer DEFAULT 0,
    block integer NOT NULL,
    "time" timestamp with time zone NOT NULL,
    tx character varying(66) NOT NULL
);


ALTER TABLE oasis.offer OWNER TO vulcan0xadmin;

--
-- Name: COLUMN offer.id; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.id IS 'Unique offer identifier';


--
-- Name: COLUMN offer.pair; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.pair IS 'Trading pair hash';


--
-- Name: COLUMN offer.maker; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.maker IS 'Offer creator address (msg.sender)';


--
-- Name: COLUMN offer.lot_gem; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.lot_gem IS 'Lot token address';


--
-- Name: COLUMN offer.lot_amt; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.lot_amt IS 'Lot amount given';


--
-- Name: COLUMN offer.bid_gem; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.bid_gem IS 'Bid token address';


--
-- Name: COLUMN offer.bid_amt; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.bid_amt IS 'Bid amount wanted';


--
-- Name: COLUMN offer.killed; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.killed IS '0 if the offer is live or block height when killed';


--
-- Name: COLUMN offer.block; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.block IS 'Block height';


--
-- Name: COLUMN offer."time"; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer."time" IS 'Block timestamp';


--
-- Name: COLUMN offer.tx; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.offer.tx IS 'Transaction hash';


--
-- Name: trade; Type: TABLE; Schema: oasis; Owner: vulcan0xadmin
--

CREATE TABLE oasis.trade (
    offer_id integer,
    pair character varying(66),
    maker character varying(66),
    lot_gem character varying(66),
    lot_amt numeric,
    taker character varying(66),
    bid_gem character varying(66),
    bid_amt numeric,
    removed boolean,
    block integer NOT NULL,
    "time" timestamp with time zone NOT NULL,
    tx character varying(66) NOT NULL
);


ALTER TABLE oasis.trade OWNER TO vulcan0xadmin;

--
-- Name: COLUMN trade.offer_id; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.offer_id IS 'Offer identifier';


--
-- Name: COLUMN trade.pair; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.pair IS 'Trading pair hash';


--
-- Name: COLUMN trade.maker; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.maker IS 'Offer creator address';


--
-- Name: COLUMN trade.lot_gem; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.lot_gem IS 'Lot token address';


--
-- Name: COLUMN trade.lot_amt; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.lot_amt IS 'Lot amount given by maker';


--
-- Name: COLUMN trade.taker; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.taker IS 'Trade creator address (msg.sender)';


--
-- Name: COLUMN trade.bid_gem; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.bid_gem IS 'Bid token address';


--
-- Name: COLUMN trade.bid_amt; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.bid_amt IS 'Bid amount matched by taker';


--
-- Name: COLUMN trade.block; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.block IS 'Block height';


--
-- Name: COLUMN trade."time"; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade."time" IS 'Block timestamp';


--
-- Name: COLUMN trade.tx; Type: COMMENT; Schema: oasis; Owner: vulcan0xadmin
--

COMMENT ON COLUMN oasis.trade.tx IS 'Transaction hash';


--
-- Name: offer_trades(oasis.offer); Type: FUNCTION; Schema: oasis; Owner: vulcan0xadmin
--

CREATE FUNCTION oasis.offer_trades(offer oasis.offer) RETURNS SETOF oasis.trade
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM oasis.trade
  WHERE oasis.trade.offer_id = offer.id
  ORDER BY oasis.trade.block DESC
$$;


ALTER FUNCTION oasis.offer_trades(offer oasis.offer) OWNER TO vulcan0xadmin;

--
-- Name: trade_offer(oasis.trade); Type: FUNCTION; Schema: oasis; Owner: vulcan0xadmin
--

CREATE FUNCTION oasis.trade_offer(trade oasis.trade) RETURNS oasis.offer
    LANGUAGE sql STABLE
    AS $$
  SELECT *
  FROM oasis.offer
  WHERE oasis.offer.id = trade.offer_id
  ORDER BY oasis.offer.id DESC
  LIMIT 1
$$;


ALTER FUNCTION oasis.trade_offer(trade oasis.trade) OWNER TO vulcan0xadmin;

--
-- Data for Name: offer; Type: TABLE DATA; Schema: oasis; Owner: vulcan0xadmin
--

INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (741, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.12, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, NULL, 7531713, 7531493, '2018-05-31 20:11:36+00', '0xc6aee40155d7be910fc40736b5ba25647fdffd1649ece8501a1a4c4a19e8a09b');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (756, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xaB2025180df1f3f3c4ab7790202bF1EA0D873130', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.01, NULL, 0, 7574132, '2018-06-04 09:57:16+00', '0x5939e7114307cb90112852ad91ea1fc64cf07856f75a047fe4edbb89f38f6471');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (730, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 2000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2.857142857142857, NULL, 0, 7529057, '2018-05-31 15:19:08+00', '0xc187f3d68972fb0262034a93a65a0cbbb75381195df4b5ecf1647c55fa7a40e2');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 1000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2, NULL, 0, 7529063, '2018-05-31 15:20:00+00', '0x7c17da3b02c072eba58e292169e16d8c23bf8108d9b3dc8b019236fef78d0e54');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (733, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.13, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, NULL, 0, 7530603, '2018-05-31 18:24:48+00', '0x82576cbd87bebcbfc147a0e9ad35c5b540b5950971d882a6355d13a09bc8bbcc');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (755, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x99b397B1573fc5041Fb38b8a0a291359f9e775b4', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.053331336666666666, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.5333133666666666, NULL, 7566941, 7566935, '2018-06-03 19:33:32+00', '0x8a5564b46d336a8291d15745982daa396274e72517497e48c7fadb035343ee01');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (734, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.2, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.38, NULL, 0, 7530766, '2018-05-31 18:44:12+00', '0x24737e3753b72f7d70637aca96a40b9ccc37d10bbd29b561ba7777a6b5a9a600');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (735, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.18, NULL, 0, 7530783, '2018-05-31 18:46:24+00', '0x8256b21bebb43d7dfc8e67e393f1e58381beb317470d908db747bc7c6abec26b');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (736, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.19, NULL, 0, 7530787, '2018-05-31 18:46:44+00', '0x19b52053cb8a14eccd9a781445a7b57b2d05bb48732111e2fb2eb9ca848b037e');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (737, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.2, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.36, NULL, 0, 7530883, '2018-05-31 18:58:24+00', '0x4b9876683043f0762fe2cc9b2bd0159548480c430d8465f9571fca91492923e4');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (738, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.2, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.36, NULL, 0, 7530913, '2018-05-31 19:02:00+00', '0x14f0423f4cf8b403fb84d86a7f8335af8de0a90cb065544ad0d9a4ee85539fb1');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (739, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.18, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, NULL, 0, 7530918, '2018-05-31 19:02:36+00', '0xfb87a89d5ddf0542ac83f8bfceb1de2a0e14d4d52c27f43d65156ed6b43c47e4');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (740, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.04583333333333333, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.055, NULL, 0, 7531452, '2018-05-31 20:06:32+00', '0xff0516dab1c5f526a4444a830ca9cce146142c4bb177b14a2ba5f8592b4649b2');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.3, '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 171.3, NULL, 0, 7536590, '2018-06-01 06:24:12+00', '0x2fb4210e76d9b2e88756d7fead3780352e59d8b34cb03b130879e3cab6b1c4e5');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (732, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.22, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.2, NULL, 7531833, 7530592, '2018-05-31 18:23:20+00', '0x1ec423d4d9a315487d62df8fb189c4a88bacd17a5713b417a18ba14febdd1baf');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (742, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.11, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, NULL, 7531856, 7531851, '2018-05-31 20:54:24+00', '0xd8e8aab42ae7d4eceb0bc98c5498c41484d4c6b5433647d0f6677fa87723e49f');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (743, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 112, NULL, 7537810, 7532042, '2018-05-31 21:17:20+00', '0xb1802cd420f2cc2b9e57114766d1670f80942af5569b342e23db4432a2fd1105');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (746, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 21, NULL, 7540984, 7537870, '2018-06-01 08:57:48+00', '0x66f98989ac9500446d619ee9983ebf49eede471b381c4d010cd3adb635c94363');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (747, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 21, NULL, 7540991, 7537935, '2018-06-01 09:05:36+00', '0x67bbafbea35359a877678030b6f8d3bf4638a9c135ac2bf4a839f7f85bfb54ff');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (728, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 11, NULL, 7516099, 7516087, '2018-05-30 16:14:36+00', '0xf9342839b7227009b62182893c48d9d641aed10df4fa640ca5408e74544cd3f9');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (748, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 112, NULL, 0, 7538694, '2018-06-01 10:38:12+00', '0xa148bc0c5befc218fe7a0dce007de7921cc642ac1f0b44997797be7232a8fa13');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (723, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, NULL, 0, 7515896, '2018-05-30 15:55:28+00', '0x9e36838cb8d874d3ec26e6c08cafaf095c765a34fa854438704260c0dce2d168');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (749, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 31, NULL, 0, 7540802, '2018-06-01 14:54:56+00', '0x29a3e122f4a67f358437b994a83352b40771027330eec91d7b880149b1309a0a');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (726, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 5000, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 8.333333333333334, NULL, 0, 7515923, '2018-05-30 15:58:04+00', '0x01cee9e3e233d3c5d4066c1af6944473c2a2558c91a080d5029b63dfd56d3a6f');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (750, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.065, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.05, NULL, 0, 7542929, '2018-06-01 19:10:08+00', '0x438b8a061e475f9155000d721309b1de35df74a3ec38be5407753a906c161f8f');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (729, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 12, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 10, NULL, 0, 7516273, '2018-05-30 16:33:12+00', '0x20177cb646296b0a58eb67bcf679cf5216c21baaaa6427b8967c90e43945883f');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (721, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 23.1, NULL, 7515551, 7515517, '2018-05-30 15:17:36+00', '0xb74b750bc40b98b5dd95836d1451c9675a7b0a8ef5729d81cac9a937bb29a788');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (751, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.04583333333333333, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.055, NULL, 7542957, 7542945, '2018-06-01 19:12:12+00', '0x7e00e4c3d4f6efaa0e42e5e402e6d8122ce54f6ab192c11278d734081b23c6f3');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (724, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.01, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.02, NULL, 7516072, 7515898, '2018-05-30 15:55:36+00', '0xf37fe18a2d22e5c84ede1c69a553458b08fee2b9dd2aeb5c79e2c63049d1312c');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (752, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.065, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.05, NULL, 0, 7542962, '2018-06-01 19:14:08+00', '0x423c511d098ac2350180af91720815172ac4e310c73e5e13a0c9979cfe806070');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (725, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, NULL, 7515923, 7515914, '2018-05-30 15:57:16+00', '0xbfa215ad39eda418b66480b6a380a0dfa973aba690565f2512bcd2539f681b8d');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (753, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 11, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 11, NULL, 0, 7554243, '2018-06-02 17:58:00+00', '0x8a22d6beeffc7a5266612bf132d75c1afa1cb5623d61b8344145a4f926bea175');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (745, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 12, NULL, 7540955, 7537825, '2018-06-01 08:52:24+00', '0x3373de74977404ff5f30b23b7935894b09ce4107b8d6bf69718c583388f91ee3');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (754, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x99b397B1573fc5041Fb38b8a0a291359f9e775b4', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, NULL, 0, 7566414, '2018-06-03 18:31:00+00', '0x2f51a9038c47498d4623e35db6bcc1c73bf1045fe1da12ee7633bb70e03c8dd2');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (722, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, NULL, 7515889, 7515877, '2018-05-30 15:53:36+00', '0xcbbe83166cbaae4d5f7a2b1198c58de59fb2d380aa6828e09283735eba6c13a9');
INSERT INTO oasis.offer (id, pair, maker, lot_gem, lot_amt, bid_gem, bid_amt, removed, killed, block, "time", tx) VALUES (727, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1, '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, NULL, 7515932, 7515927, '2018-05-30 15:58:32+00', '0x8ef88de44e3e043c8920154803aa682ad9a1417a15d3f3c195b18ce52397ee6f');


--
-- Data for Name: trade; Type: TABLE DATA; Schema: oasis; Owner: vulcan0xadmin
--

INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.04553415061295972, NULL, 7570711, '2018-06-04 03:06:48+00', '0x48dc22da173858c4fdb8d50a754dbaabfd6661ee15a5b3c8b8a0061fda55bb6c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.8326988596146468, '0x12F4D161B380513aDA888368ff86A3b932CC0F43', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 416.3494298073234, NULL, 7572916, '2018-06-04 07:31:24+00', '0x83b7c73c233a6cae4187c8f005712b96390777bb2ea5e326033ba2859943ae74');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999969, '0xa8Be6F3336A72Ac013483CaaeD0Fb9752dB0a712', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000175131348511383, NULL, 7574286, '2018-06-04 10:15:48+00', '0x11f0d996ae461db3aa02cb152a77672e4fc57c10f52a67f9484c82921390c23a');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999969, '0xa8Be6F3336A72Ac013483CaaeD0Fb9752dB0a712', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000175131348511383, NULL, 7574291, '2018-06-04 10:16:24+00', '0x20e5422d6781c6607e4bcf78f51a5f70e95f06cf045ed2352372a8f7d173e415');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (756, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xaB2025180df1f3f3c4ab7790202bF1EA0D873130', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.01, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 5, NULL, 7574308, '2018-06-04 10:18:20+00', '0x96e232747b4cabd29f5cf2a0db30c0f3d7aa2e0fb4542a7aac2b09de4473185b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (753, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0x5bd25bAbFfD6bd3E17fD50f4AEd7667A40EC9CbC', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.1, '0xfF390B9e6263f988Eacc3aaC04597F4c8C436888', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.1, NULL, 7574311, '2018-06-04 10:18:48+00', '0x5df87c75d659ea1fe01f0b1206d98f54f616dbc7b8e326873193aeee509917bb');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.009999999999999797, '0xfF390B9e6263f988Eacc3aaC04597F4c8C436888', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000017513134851138, NULL, 7574318, '2018-06-04 10:19:32+00', '0xe6206f3279b74d62c674b89663805f6d4c98022dd28e231fbc028de86a7cfee5');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000099999999999781, '0x1B68F4C1681E723F5c6db120CC6a7dA58db37c37', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000000175131348511, NULL, 7575381, '2018-06-04 12:27:12+00', '0xc2bad201e56a3bae2a28852654659caf5e35f2eea710c4da8a2fd7a87a53ba2f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (7, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.2, '0x4831598dD075161242bFA6c1C5773EF6F04a5F29', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.1, NULL, 7575833, '2018-06-04 13:21:48+00', '0xa23e379de9bdc4aeb32ef1940ed790a517316e6ef6f9459f061e188f4a313f05');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (726, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.1, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 60, NULL, 7518713, '2018-05-30 20:37:04+00', '0xe8cbc24bc7398afc1036e75b8faa91478b5cf8a3d7508023d37c7e73b3c01b30');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999935, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000138888888888888, NULL, 7519444, '2018-05-30 21:50:12+00', '0xc1e664f4294c0b4dfc4a396ecb91fa5b67202da39a7669dc29ccd8e0aa4db05b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 15, '0xc6834cCC2408A031ec834358c64B5676032e4069', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.020833333333333332, NULL, 7518469, '2018-05-30 20:12:48+00', '0xe9cf67e979bb646804ac16ffc68483d7be382c2865d4f159ca05fc577650040e');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999935, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000138888888888888, NULL, 7519457, '2018-05-30 21:51:28+00', '0xd6a6dd6bf6531e1be316e96cdc37b3243a7e076d316c35fb0380de07381452c9');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519645, '2018-05-30 22:10:24+00', '0x074c915d70c8934393c89e054cf90eaa556abb53a4200edf80e950408471d7af');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 6, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.008333333333333333, NULL, 7521533, '2018-05-31 01:19:08+00', '0xc4332a3ab22ee33e357f39546e1987661f0b74074ce99c5f3a20c9d29a7f3054');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7529885, '2018-05-31 16:58:32+00', '0x78366ec1b5041070287af25405c6954b0fa3d04cc66e6ceb307b38184fcd1bb9');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (738, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.36, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.2, NULL, 7530918, '2018-05-31 19:02:36+00', '0xfb87a89d5ddf0542ac83f8bfceb1de2a0e14d4d52c27f43d65156ed6b43c47e4');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.1, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 50, NULL, 7536265, '2018-06-01 05:45:12+00', '0xbf04b89c78efef2b53b568ae3c1b2693cec292233988f90cb944a19f634502d0');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999969, '0x3d0a4C0c4F4648f339366813336Ca9Ea53301d61', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000175131348511383, NULL, 7537349, '2018-06-01 07:55:08+00', '0xeb1e687ef90640fc8b3f0d23f5147f48266818e23a6004cdc92bc43621a29b56');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (722, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.5, '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.5, NULL, 7515888, '2018-05-30 15:54:32+00', '0x7becf3803a443f02e29c9f6684dcde103c8d1e098fa675f6e3dfea3b9489fcd7');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519477, '2018-05-30 21:53:36+00', '0x9774e67b8616ae01ec4235a13b6e36343217230473a8e2a1485e763d3fb5d199');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519534, '2018-05-30 21:59:12+00', '0xf053b8974f6edcb35f37d3c2c58272369c4bd010a5985293ce88b7e8f3147eff');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 6, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.008333333333333333, NULL, 7520797, '2018-05-31 00:05:40+00', '0xd9f9318b848b79224a568671502d711fa11849f4cf4f3b212f134b495a548474');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7524100, '2018-05-31 05:36:32+00', '0xe50cff54f1d48791f5b9159a23e0b00faa84f09ccea97fbcfb13586d885b85f1');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (735, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.18, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.1, NULL, 7530792, '2018-05-31 18:47:20+00', '0xe518da16b3ee7596b8eeb9f3eb7ac65e5cfd6330034abe46ecaf5f2f3bbed0d8');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (7, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.05, NULL, 7532483, '2018-05-31 22:10:44+00', '0xdab0775151b5309af1b6770934f481fe530d0e73fd7776f5d84e514fc81e89cc');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (750, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.05, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.065, NULL, 7542945, '2018-06-01 19:12:12+00', '0x7e00e4c3d4f6efaa0e42e5e402e6d8122ce54f6ab192c11278d734081b23c6f3');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (726, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000009999999999999, '0x1B68F4C1681E723F5c6db120CC6a7dA58db37c37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.006, NULL, 7516297, '2018-05-30 16:35:36+00', '0x2e1909e88ddd33f4dcaa56a8bcc06dff8d5e9020271c089c72a576513fab5270');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519495, '2018-05-30 21:55:24+00', '0x3be8a23c4e741605e4392bfece14aa0b848232f080e840439f740d2b1ea73f37');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519621, '2018-05-30 22:08:00+00', '0xc520c8ee99afdd68f31e4b34f21700c3d7ed4d3612efece61e4ba4d645b7ca0c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7521012, '2018-05-31 00:27:12+00', '0x4b3ead8d6d34a2816b9de0f9886f95b374dbd8a46117b943d7dbfde72e258dc2');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7529690, '2018-05-31 16:35:08+00', '0x651407b4350414aa3ef599a6e0f01feaeba99da0c1c41eb317988fffed5e23b5');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (737, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.36, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.2, NULL, 7530909, '2018-05-31 19:01:28+00', '0x48dad8b1eb27c256f7beba0faee0de823945739b7e1ae2f1e47873ab45438d6d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7536055, '2018-06-01 05:20:00+00', '0x2875c96119937baeab029dc67c684b24df828a630818ae649161a54f99af72dd');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (56, '0x2375b9416fbc3b519d8867d4bc59b82bd7942932cf1599248c1e3f30f6d3783a', '0x01349510117dC9081937794939552463F5616dfb', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03449005, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 6.89801, NULL, 7536782, '2018-06-01 06:47:08+00', '0x58df6efc810446b5279fa7e09d18049fb6b3871eeaef6e547cb1ad47b51ea72b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.00022, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.11, NULL, 7536920, '2018-06-01 07:03:48+00', '0x6c7d1c4c944fb070f309a9436fc70467a1ab91f29fe2d06bb415412552638141');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (7, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.000000664309931252, '0x86944F4Dd808005197907bf9547129e997F745C6', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.000000332154965626, NULL, 7544683, '2018-06-01 22:41:00+00', '0xb4b32aab6ccf5fd242338e0c5ec7f73633f3db12f3dd719b9982bd7f04ecc3cd');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519504, '2018-05-30 21:56:12+00', '0x067e4d4f626ebe0906a1494fcdd6a02197a3150e841459e02b7be74e1d92436d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519513, '2018-05-30 21:57:12+00', '0xae4050659fa7d6ac23dbb82f60ff41ce2b4c83a7af0d4eb1ed5bf2dda63bb8e9');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519728, '2018-05-30 22:18:32+00', '0x35946f675570376b57f60ce24fcaddfaafdfdb8f140f62d701443d0aa255874c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7521638, '2018-05-31 01:29:44+00', '0x9bd0fd3c3053311ce2aa0221b662fbf76c13c8874798269c95195a5c536d7d1a');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (734, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.38, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.2, NULL, 7530772, '2018-05-31 18:44:56+00', '0x7bbe54a1b54ae5573239ad31d4b91a7340ff15c72f485fe6a268d764aa1c07dd');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (740, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.055, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.04583333333333333, NULL, 7531668, '2018-05-31 20:32:36+00', '0x42f8a53f9c706dd2e15f1976181144281b1ddfe562967a7d95c7a4ca8bb6884b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.00001, '0x1B68F4C1681E723F5c6db120CC6a7dA58db37c37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.005, NULL, 7539354, '2018-06-01 11:59:36+00', '0x5feb7e686e9bf338642c0b6ef534c624e1f5f2cc188b5f4cf0195b375ee84426');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (723, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 1, '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 1, NULL, 7515903, '2018-05-30 15:56:08+00', '0xe19c321168dd50e069dfa363b72f8d7fe29b43f3ea48e186b862b07d8c84cd34');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519506, '2018-05-30 21:56:20+00', '0x42010b01fa932b96b7c60545c152de05b45b481cd60cec2220623234f755cb97');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519681, '2018-05-30 22:14:00+00', '0xd9f7fa658659cb02ad67c8e72878c1acd345697045c22daec0fa5548d84a4dce');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7521540, '2018-05-31 01:20:00+00', '0x2cdb89971756a50e009159aefaa62e3d7857e89a2c6c948c9e1290cd8d53c152');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (730, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 2.857142857142857, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 2000, NULL, 7530216, '2018-05-31 17:38:12+00', '0x4edd93758191eadda996293a844471f6ca808782ee8ce9b2010e2dbbb8465fde');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (739, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.1, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.18, NULL, 7531408, '2018-05-31 20:01:24+00', '0xb976a037fae00d3f94c73edd2506e2546cbd56fddaa8ad739f51c93ad10fcae0');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 10, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.017513134851138354, NULL, 7536859, '2018-06-01 06:56:20+00', '0x43256c6ee4b2793a4631b250aad598f517ea56aba91fb2b255018df9fc8bad57');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 13.32916302578213, '0x86944F4Dd808005197907bf9547129e997F745C6', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.023343542952332975, NULL, 7536600, '2018-06-01 06:25:24+00', '0x003971ace66960094d20f5fd201d7c824b624c7fef3302b77a95ee9445822d08');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (7, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.1, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.05, NULL, 7537125, '2018-06-01 07:28:24+00', '0x8ad15cdf885bdd1411df16ce74973329ce6784963f38fd2464cf0b52d1f00b2f');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519507, '2018-05-30 21:56:36+00', '0xb514d2e88a13a49240ae62106b3901db711514af5c78b0faa1d6e23b1119edd2');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519687, '2018-05-30 22:14:36+00', '0x09b975d59234042c24eba3020f28b423e3771bea369dfdfc60cf102bb457c2d8');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 6, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.008333333333333333, NULL, 7521595, '2018-05-31 01:25:28+00', '0x92b08746dd4b59d2971fc28040983f6d4506d1852f13428397e9fdbf529effee');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7530294, '2018-05-31 17:47:40+00', '0x5e7e2488e608044f1791febaa4ee278337eefa54b86fdc00cd052b5b01a4276c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (733, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.05, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.065, NULL, 7531445, '2018-05-31 20:05:44+00', '0x69cc1a37a39e54a8606475300e7496c456445f1ee64e22b6c16ec868890b4349');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999969, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000175131348511383, NULL, 7536910, '2018-06-01 07:02:36+00', '0x2109ac6288c20bc72f5df17c687160d7538f6bf9628fa74b3669639ec0a09c74');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.00001, '0x1B68F4C1681E723F5c6db120CC6a7dA58db37c37', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.005, NULL, 7539401, '2018-06-01 12:05:08+00', '0x4b09fa6d746c3f79167aa87996fbda4a3feb530715c7e0182ff0603f69fc636b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (729, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.00001, '0x1B68F4C1681E723F5c6db120CC6a7dA58db37c37', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.000012, NULL, 7516285, '2018-05-30 16:34:24+00', '0x2886daa541b8a6a5eec2c3658f0ed301a521d284a9fd1620194cae18d4f1583e');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519529, '2018-05-30 21:58:40+00', '0x8ad823e7e64b737434e491afcd32d14005183a986d810da9aaf849303e0655a7');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519735, '2018-05-30 22:19:24+00', '0x4e315b8d22d6dc21019f676f609cd2165a3a514671588df85a17968560aab873');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7522085, '2018-05-31 02:14:36+00', '0x4b6ecec0a7bae1b6bca2e3232f8c937a09bcbf84c6e0c011a72d9b5ae335c68c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (600, '0x2375b9416fbc3b519d8867d4bc59b82bd7942932cf1599248c1e3f30f6d3783a', '0x2F0C2caC736287339ad24992EEEC1c58C7f207A7', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.1, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.001, NULL, 7536870, '2018-06-01 06:57:48+00', '0x33a9969ba8aaabb12f81aae94af02d0c344ce37cb62bc64d5fe99bc0a1a4c62d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (194, '0x2375b9416fbc3b519d8867d4bc59b82bd7942932cf1599248c1e3f30f6d3783a', '0xfeF6763DA6Ba3B72fbE97f9Ee55AB6A4D0ABB03F', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.01, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 2.04, NULL, 7536713, '2018-06-01 06:38:48+00', '0x0bf12878e0c51dcfc91437dee3e254d6a7978d0dc6f6b8330ca270329f94eb8c');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.04553415061295972, NULL, 7537145, '2018-06-01 07:30:48+00', '0x8bf98945becaa31a513e19332c6e5d1aca58d20261d69541dab800f397baee0b');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (731, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 1, '0xEE419971E63734Fed782Cfe49110b1544ae8a773', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 500, NULL, 7563818, '2018-06-03 13:19:24+00', '0x9fbb4c41429603a12484b42660755503e3740624869012d12a20da505e3f8df5');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519603, '2018-05-30 22:06:12+00', '0x8c59c01c5cce6cd979e614d1fd370a2068dc877090929ca0a78ddf7749f6f1fd');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7520997, '2018-05-31 00:25:36+00', '0xf1be503b74e58f58919542cda5d72a0f9112cbf4f2b0fdefc429cec533f98bc9');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (726, '0x60897d7ad377a1bbe0812afdb9d9146c2517192fb4c1d7b0d1c8342eef304a8b', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 8.233323333333333, '0x31f4Dc7408562425184d25Cf3B1151b4A97003a6', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 4939.994, NULL, 7525281, '2018-05-31 07:46:00+00', '0xccb39e445910ff647dd12cd2823ae8d4e015849586c14768ad09db99874d19c2');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999969, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000175131348511383, NULL, 7536930, '2018-06-01 07:05:00+00', '0x1431684a443b94cbca212fb58bd6bff4cbe1107388fb67d0095052771927062d');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519663, '2018-05-30 22:12:12+00', '0x4a9da50a2cb6d80639bcad3fbf489fe9320262a3bf9c1c27d4c274594f75972e');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 13, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.018055555555555554, NULL, 7521620, '2018-05-31 01:27:56+00', '0xf4c97b18ad395df250341d6f368514e1ac1067c1ec8d0ba39fa4bce7e086cfe8');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.03611111111111111, NULL, 7530722, '2018-05-31 18:38:56+00', '0xb9b63d870c77bf2e92c0290b1c9e35df521020cc3df17f1768c626ef3e7344f8');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (729, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.02, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.024, NULL, 7531470, '2018-05-31 20:08:44+00', '0x5d38cc914eda8712602d39d2dac9a95b525651af50105abd9e61cc5baa12fac3');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.09999999999999969, '0x0844f53ef8a27C573bb89EB720ef77DFC6C78585', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000175131348511383, NULL, 7536934, '2018-06-01 07:05:20+00', '0xdd641ae1fb8461db3a1b4ed62a0d57e8b1551e46e182f39d208991e8f6b7f1c3');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7519676, '2018-05-30 22:13:28+00', '0xc33667ae3039f97b36972fb81c058c58a62d8b8c1a7448543c4c17d44916f419');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.9999999999999993, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.001388888888888888, NULL, 7521602, '2018-05-31 01:26:08+00', '0x24f7d119e55a992450f5e5c9e073bcd7dee3859aeb98153f5656f5258a143a94');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (7, '0xb65df2816e566ca590b7d912da97993fe8abeb2bc0034ee376c9b4e9c2586259', '0xdB33dFD3D61308C33C63209845DaD3e6bfb2c674', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.2, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.1, NULL, 7530684, '2018-05-31 18:34:28+00', '0xd067a587eecc333a91ac780bf1ddcce47349d1d20657128913151013605dece0');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (733, '0xf123cf7c0e4880a64ebda7391ad25807fef7cca2b0dd34281ef3904b9bde65a9', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.05, '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD', 0.065, NULL, 7531452, '2018-05-31 20:06:32+00', '0xff0516dab1c5f526a4444a830ca9cce146142c4bb177b14a2ba5f8592b4649b2');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (744, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0xf0E90739550992Fcf37fe4DCB0b47708ca0ff609', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 26, '0x717bc9648b627316718Fe93f4cD98056E53a8C8d', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.04553415061295972, NULL, 7544177, '2018-06-01 21:40:08+00', '0xb9ac1ca5383190e8f340d8ed41b48a10b2b7697de2438308699958c11807e4a6');
INSERT INTO oasis.trade (offer_id, pair, maker, lot_gem, lot_amt, taker, bid_gem, bid_amt, removed, block, "time", tx) VALUES (685, '0xb4188a082cd74fce761abb4adc0b9bb37f26d28c411be07cfbdf5c1fe7ebbe19', '0x1981f2deaB89528922112dAb6cD2AC2c0dc0a841', '0xd0A1E359811322d97991E03f863a0C30C2cF029C', 0.00009999999999936, '0x1B68F4C1681E723F5c6db120CC6a7dA58db37c37', '0xC4375B7De8af5a38a93548eb8453a498222C4fF2', 0.000000138888888888, NULL, 7516303, '2018-05-30 16:36:12+00', '0x4818a16802161f1ede3c44983fabba9e27d9cb104e8bb0627034109ecb46ccd9');


--
-- Name: offer offer_pkey; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.offer
    ADD CONSTRAINT offer_pkey PRIMARY KEY (id);


--
-- Name: offer offer_tx_key; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.offer
    ADD CONSTRAINT offer_tx_key UNIQUE (tx);


--
-- Name: trade trade_tx_key; Type: CONSTRAINT; Schema: oasis; Owner: vulcan0xadmin
--

ALTER TABLE ONLY oasis.trade
    ADD CONSTRAINT trade_tx_key UNIQUE (tx);


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