
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


    