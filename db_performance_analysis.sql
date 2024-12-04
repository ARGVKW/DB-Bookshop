-- Customer tábla teszt adatokkal való feltöltése
--
INSERT INTO customer(email, first_name, last_name, country, city, address, phone)
SELECT
  'person' || num || '@example.com',
  LEFT(md5(random()::text), 8),
  LEFT(md5(random()::text), 8),
  CASE
    WHEN random() <= 0.8 THEN 'USA'
    ELSE CASE
      WHEN random() < 0.5 THEN 'Hungary'
      ELSE 'Japan'
    END
  END,
  LEFT(md5(random()::text), 12),
  LEFT(md5(random()::text), 25),
  to_char(random() * 10000000000, 'FM(000) 000-0000')
FROM generate_series(1, 10000) as num;

-- Book tábla teszt adatokkal való feltöltése
--
INSERT INTO book(title, description, author, price, stock)
SELECT
  LEFT(md5(random()::text), 8),
  LEFT(md5(random()::text), 25),
  LEFT(md5(random()::text), 8),
  (round((random() * 100)::numeric, 2 )),
  (random() * 100)::integer
FROM generate_series(1, 10000);

-- Rendelés tábla teszt adatokkal való feltöltése
--
INSERT INTO "order"(store_id, customer_id, status, created)
SELECT
  1,
  (random() * 10000)::integer + 1,
  CASE
    WHEN random() <= 0.75 THEN 'delivered'
    ELSE CASE
      WHEN random() <= 0.5 THEN 'cart'
      ELSE CASE
        WHEN random() < 0.5 THEN 'processing'
        ELSE CASE
          WHEN random() < 0.5 THEN 'paid'
          ELSE 'unpaid'
        END
      END
    END
  END::order_status,
  now() - (random() * 1000 || ' days')::interval
FROM generate_series(1, 100000);

-- Rendelés tételek tábla teszt adatokkal való feltöltése
--
INSERT INTO order_item(order_id, book_id, quantity)
SELECT DISTINCT ON (order_id, book_id)
  "order".order_id as order_id,
  (random() * 20000)::integer + 1 as book_id,
  (random() * 5)::integer + 1
FROM "order"
JOIN generate_series(1, 10)
  ON random() < 0.5;



-- Megrendelések megjelenítése
--
EXPLAIN ANALYSE
SELECT order_id, 
       status, 
	   store.name, 
	   store.tax_id, 
	   store.address, 
	   customer.first_name, 
	   customer.last_name, 
	   book.author, 
	   book.title, 
	   quantity, 
	   price as "unit price", 
	   (SELECT sum(price) FROM order_item JOIN book USING (book_id) WHERE order_item.order_id = "order".order_id) as "order total",
	   created
  FROM "order"
  JOIN order_item USING (order_id)
  JOIN store USING (store_id)
  JOIN customer USING (customer_id)
  JOIN book USING (book_id);