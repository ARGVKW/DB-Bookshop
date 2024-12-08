
-- Készlethiányos könyvek adatainak lekérdezése
SELECT * FROM book WHERE stock = 0;

-- Legkevesebb, de még készleten lévő könyv adatainak lekérdezése
SELECT * FROM book WHERE stock = (SELECT MIN(stock) FROM book WHERE stock > 0);

-- Legtöbb készleten lévő könyv adatainak lekérdezése
SELECT * FROM book WHERE stock = (SELECT MAX(stock) FROM book);

-- Legtöbbet eladott könyvek adatainak lekérdezése
SELECT book_id, title, author, price, stock, SUM(quantity) AS sold 
  FROM book
  JOIN order_item USING (book_id)
 GROUP BY book_id
 ORDER BY sold DESC;

-- Egy adott vásárló által vásárolt könyvek adatainak lekérdezése
SELECT book_id, title, author, price, stock, quantity 
  FROM "order"
  JOIN order_item USING (order_id)
  JOIN book USING (book_id)
  JOIN customer USING (customer_id)
 WHERE customer_id = 1;

-- A legtöbb könyvet vásárolt vásárló adatainak lekérdezése
SELECT customer_id, first_name, last_name, email, country, city, address, phone, SUM(quantity) AS bought 
  FROM customer 
  JOIN "order" USING (customer_id) 
  JOIN order_item USING (order_id)
 GROUP BY customer_id, first_name, last_name, email, country, city, address, phone 
 ORDER BY bought DESC;

-- Egy adott vásárló által vásárolt könyvek, amelyeket még nem szállítottak ki
SELECT book_id, customer_id, title, author, price, stock, quantity, status
  FROM book
  JOIN order_item USING (book_id)
  JOIN "order" USING (order_id)
  JOIN customer USING (customer_id)
 WHERE customer_id=65 AND status = 'paid';

-- Kosárban lévő könyvek adatainak lekérdezése
SELECT book_id, title, author, price, stock, quantity, status
  FROM book
  JOIN order_item USING (book_id)
  JOIN "order" USING (order_id)
 WHERE status = 'cart';

-- Kiszállított könyvek adatainak lekérdezése
SELECT book_id, title, author, price, stock, quantity, status
  FROM book
  JOIN order_item USING (book_id)
  JOIN "order" USING (order_id)
 WHERE status = 'delivered';


-- Számlák tételes lekérdezése a vásárló és az áruház adataival
--
SELECT invoice_id as "Számla sorszáma", 
       store.name as "Üzlet", 
       store.tax_id as "Üzlet adószáma", 
       store.address as "Üzlet címe", 
       customer.first_name||' '||customer.last_name as "Vásárló neve", 
       customer.address||', '||customer.city||', '||customer.country as "Vásárló címe", 
       book.author||' - '||book.title as "Könyv szerzője, címe",  
       quantity as "Mennyiség", 
       invoice_price as "Egységár",
       price * quantity as "Részösszeg", 
       total as "Végösszeg", 
       tax as "ÁFA", 
       created as "Dátum"
  FROM invoice
  JOIN invoice_item USING (invoice_id)
  JOIN store USING (store_id)
  JOIN customer USING (customer_id)
  JOIN book USING (book_id);

-- Rendelések tételes lekérdezése egy adott országra és végösszeg-tartományra szűrve
--
SELECT order_id as "Rendelésazonosító",
       store.name as "Üzlet",
       customer.first_name||' '||customer.last_name as "Vásárló neve", 
       customer.address||', '||customer.city||', '||customer.country as "Vásárló címe", 
       book.author||' - '||book.title as "Könyv szerzője, címe",  
       quantity as "Mennyiség", 
       price as "Egységár",
       price * quantity as "Részösszeg",
       total as "Végösszeg",
       tax as "ÁFA", 
       created as "Dátum"
  FROM "order"
  JOIN order_item USING (order_id)
  JOIN store USING (store_id)
  JOIN customer USING (customer_id)
  JOIN book USING (book_id)
 WHERE country = 'Japan' AND total > money(1000.00)
 ORDER BY order_id, author
