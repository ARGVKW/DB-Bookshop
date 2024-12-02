-- Tárolt eljásás a számla generálására a vásárlás adatai alapján
--
CREATE OR REPLACE PROCEDURE generate_invoice(IN order_id integer) AS $$
DECLARE
    store_id integer;
    customer_id integer;
	  afa numeric(2,0);
    total numeric(2,0);
    tax numeric(2,0);
    invoice_id integer;
    book_id integer;
    title character varying(255);
    quantity integer;
    invoice_price numeric(2,0);
BEGIN
    SELECT store_id, customer_id INTO store_id, customer_id
    FROM "order"
    WHERE order_id = generate_invoice.order_id;

    afa := 0.27;
    total := 0;
    tax := 0;
    
    FOR book_id, quantity, invoice_price IN
        SELECT book_id, quantity, price
        FROM order_item
        JOIN book USING (book_id)
        WHERE order_id = generate_invoice.order_id
    LOOP
        total := total + invoice_price * quantity;
        tax := tax + invoice_price * quantity * afa;
        
        INSERT INTO invoice_item (book_id, invoice_id, quantity, invoice_price)
        VALUES (book_id, invoice_id, quantity, invoice_price);
    END LOOP;
    
    INSERT INTO invoice (order_id, store_id, customer_id, total, tax)
    VALUES (generate_invoice.order_id, store_id, customer_id, total, tax)
    RETURNING invoice_id INTO invoice_id;
    
    UPDATE "order"
    SET status = 'paid', updated = now()
    WHERE order_id = generate_invoice.order_id;
    
    RAISE NOTICE 'Számla elkészült: %', invoice_id;
END;
$$ LANGUAGE plpgsql;
  