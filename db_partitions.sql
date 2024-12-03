-- Partícionálás a customer táblán ország szerint
--
CREATE TABLE customer_usa PARTITION OF customer
FOR VALUES IN ('USA');

CREATE TABLE customer_hun PARTITION OF customer
FOR VALUES IN ('Hungary');

CREATE INDEX idx_customer_country ON customer (country);
