-- Partícionálás a customer táblán ország szerint
--
CREATE TABLE customer_usa PARTITION OF customer
FOR VALUES IN ('USA');


CREATE TABLE customer_hun PARTITION OF customer
FOR VALUES IN ('Hungary');

CREATE TABLE customer_jpn PARTITION OF customer
FOR VALUES IN ('Japan');

-- Egyedi indexek az email mezőre a partíciókban
--
ALTER TABLE customer_usa ADD UNIQUE (email);
ALTER TABLE customer_hun ADD UNIQUE (email);
ALTER TABLE customer_jpn ADD UNIQUE (email);

-- Indexek a country mezőre
CREATE INDEX idx_customer_country ON customer (country);

-- Indexek az email mezőre
CREATE INDEX idx_customer_email ON customer (email);
