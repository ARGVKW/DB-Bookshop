-- Partícionálás a customer táblán ország szerint
--
CREATE TABLE customer_usa PARTITION OF customer
FOR VALUES IN ('USA');


CREATE TABLE customer_hun PARTITION OF customer
FOR VALUES IN ('Hungary');

CREATE TABLE customer_jpn PARTITION OF customer
FOR VALUES IN ('Japan');

-- Indexek a country mezőre a customer táblán
CREATE INDEX idx_customer_country ON customer (country);

-- Indexek az email mezőre a customer táblán
CREATE INDEX idx_customer_email ON customer (email);
