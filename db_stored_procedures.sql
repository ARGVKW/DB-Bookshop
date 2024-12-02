-- Tárolt eljásás a számla generálására a vásárlás adatai alapján
--
CREATE OR REPLACE PROCEDURE generate_invoice(IN order_id integer, OUT invoice_id integer) AS $$
DECLARE
    invoice_id integer;
    store_id integer;
    customer_id integer;
    book_id integer;
    quantity integer;
    i_book_id integer;
    i_quantity integer;
    invoice_price numeric(2,0);
    grand_total numeric(2,0);
    tax numeric(2,0);
    afa numeric := 0.27;
BEGIN
    SELECT "order".store_id, "order".customer_id
      INTO store_id, customer_id
      FROM "order"
     WHERE "order".order_id = generate_invoice.order_id;
    
    SELECT SUM(book.price * order_item.quantity)
      INTO grand_total
      FROM order_item
      JOIN book USING (book_id)
     WHERE order_item.order_id = generate_invoice.order_id;

    tax := grand_total * afa;
    
    INSERT INTO invoice (order_id, store_id, customer_id, total, tax)
    VALUES (generate_invoice.order_id, store_id, customer_id, grand_total, tax)
    RETURNING invoice.invoice_id INTO invoice_id;
    
    FOR i_book_id, i_quantity IN
        SELECT order_item.book_id, order_item.quantity
          FROM order_item
         WHERE order_item.order_id = generate_invoice.order_id
    LOOP
        SELECT book.price
          INTO invoice_price
          FROM book
         WHERE book.book_id = i_book_id;
        
        INSERT INTO invoice_item (book_id, invoice_id, quantity, invoice_price)
        VALUES (i_book_id, invoice_id, i_quantity, invoice_price);
    END LOOP;
END;
$$ LANGUAGE plpgsql;



DO $$
DECLARE
  new_invoice_id integer;
BEGIN
  -- Számla generálása az adott megrendelés alapján
  CALL generate_invoice(1, new_invoice_id);
  RAISE NOTICE 'Számlagenerálás kész. Számla sorszáma: %', new_invoice_id;

END;
$$;

-- Számla tételes lekérdezése a vásárló és az áruház adataival
SELECT invoice_id, store.name, store.tax_id, store.address, customer.first_name, customer.last_name, book.author, book.title, quantity, invoice_price, total, tax, created
  FROM invoice
  JOIN invoice_item USING (invoice_id)
  JOIN store USING (store_id)
  JOIN customer USING (customer_id)
  JOIN book USING (book_id)
WHERE invoice_id = new_invoice_id;
