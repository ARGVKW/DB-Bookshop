
-- Függvény a könyv készletének csökkentésére a rendelés kifizetésekor
CREATE OR REPLACE FUNCTION decrement_stock_on_payment() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'paid' THEN
        UPDATE book SET stock = stock - NEW.quantity
        FROM order_item
        WHERE book.book_id = order_item.book_id AND order_item.order_id = NEW.order_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger a könyv készletének csökkentésére a rendelés kifizetésekor
CREATE TRIGGER decrement_stock_on_payment AFTER UPDATE ON "order"
    FOR EACH ROW
    EXECUTE FUNCTION decrement_stock_on_payment();

-- Függvény a rendelés végösszegének és adótartalmának kiszámítására
CREATE OR REPLACE FUNCTION calculate_order_total() RETURNS TRIGGER AS $$
DECLARE
	CURR record := CASE WHEN TG_OP = 'DELETE' THEN OLD ELSE NEW END;
    afa numeric := 0.27;
BEGIN
    CURR.total = (SELECT SUM(book.price * order_item.quantity)
                 FROM order_item
                 JOIN book ON order_item.book_id = book.book_id
                 WHERE order_item.order_id = CURR.order_id);
    CURR.tax = CURR.total * afa;
    RETURN CURR;
END;
$$ LANGUAGE plpgsql;

-- Függvény a rendelés végösszegének és adótartalmának frissítésére az order táblában
--
CREATE OR REPLACE FUNCTION update_order_total() RETURNS TRIGGER AS $$
DECLARE
	CURR record := calculate_order_total();
BEGIN
    UPDATE "order"
       SET total = CURR.total, tax = CURR.tax
     WHERE "order".order_id = update_order_total.order_id;
    RAISE NOTICE 'Rendelés végösszegének és adótartalmának frissítése kész.';
    RETURN CURR;
END;
$$ LANGUAGE plpgsql;

-- Trigger a rendelés végösszegének és adótartalmának frissítésére az order táblában
CREATE TRIGGER update_order_total AFTER INSERT OR UPDATE OR DELETE ON order_item
    FOR EACH ROW
    EXECUTE FUNCTION update_order_total();

    