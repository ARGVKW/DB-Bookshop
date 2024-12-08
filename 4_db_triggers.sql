
-- Triggerfüggvény a könyv készletének csökkentésére a rendelés kifizetésekor
--
CREATE OR REPLACE FUNCTION decrement_stock_on_payment() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'paid' THEN
        BEGIN
            UPDATE book SET stock = stock - order_item.quantity
            FROM order_item
            WHERE book.book_id = order_item.book_id AND order_item.order_id = NEW.order_id;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE WARNING 'Készlethiány: %', SQLERRM;
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger a könyv készletének csökkentésére a rendelés kifizetésekor
--
CREATE TRIGGER decrement_stock_on_payment AFTER UPDATE ON "order"
    FOR EACH ROW
    EXECUTE FUNCTION decrement_stock_on_payment();


-- Függvény a rendelés végösszegének és adótartalmának kiszámítására
--
CREATE TYPE order_total AS (total money, tax money);
CREATE OR REPLACE FUNCTION calculate_order_total(CURR record) RETURNS order_total AS $$
DECLARE
	CURR record := calculate_order_total.CURR;
    result order_total;
    afa numeric := 0.27;
BEGIN
    result.total = (SELECT SUM(book.price * order_item.quantity)
                 FROM order_item
                 JOIN book ON order_item.book_id = book.book_id
                 WHERE order_item.order_id = CURR.order_id);
    result.tax = result.total * afa;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Triggerfüggvény a rendelés végösszegének és adótartalmának frissítésére az order táblában
--
CREATE OR REPLACE FUNCTION update_order_total() RETURNS TRIGGER AS $$
DECLARE
    CURR record := CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
	calculated order_total := calculate_order_total(CURR);
BEGIN
    UPDATE "order"
       SET total = calculated.total, tax = calculated.tax
     WHERE "order".order_id = CURR.order_id;
    RETURN CURR;
END;
$$ LANGUAGE plpgsql;

-- Trigger a rendelés végösszegének és adótartalmának frissítésére az order táblában
--
CREATE TRIGGER update_order_total AFTER INSERT OR UPDATE OR DELETE ON order_item
    FOR EACH ROW
    EXECUTE FUNCTION update_order_total();


-- Trigger a tárolt eljárás hívására a számla generálásához
--
CREATE OR REPLACE FUNCTION call_generate_invoice() RETURNS TRIGGER AS $$
DECLARE
  invoice_id integer;
BEGIN
    CALL generate_invoice(NEW.order_id, invoice_id);
    RAISE NOTICE 'Számlagenerálás kész. Számla sorszáma: %', invoice_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger a számla generálására a rendelés kifizetésekor
--
CREATE TRIGGER generate_invoice AFTER INSERT OR UPDATE ON "order"
    FOR EACH ROW
    WHEN (NEW.status = 'paid')
    EXECUTE FUNCTION call_generate_invoice();
