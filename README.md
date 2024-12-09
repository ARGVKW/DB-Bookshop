# DB-Bookshop 

Adatbázisszerverek - B-GY-DBSERV<br> 
Varga Gábor - ARGVKW

GitHub ▶ https://github.com/ARGVKW/DB-Bookshop

## Tartalom<!-- omit in toc -->

- [DB-Bookshop](#db-bookshop)
  - [1. Bevezetés](#1-bevezetés)
  - [2. Adatbázisterv](#2-adatbázisterv)
    - [2.1. Táblák](#21-táblák)
      - [2.1.1. Store tábla: A könyvesbolt adatai és elérhetőségei](#211-store-tábla-a-könyvesbolt-adatai-és-elérhetőségei)
      - [2.1.2. Book tábla: A könyvek adatait tartalmazza](#212-book-tábla-a-könyvek-adatait-tartalmazza)
      - [2.1.3. Customer tábla: A vásárlók adatait tartalmazza](#213-customer-tábla-a-vásárlók-adatait-tartalmazza)
      - [2.1.4. Order tábla: A megrendelések adatait tartalmazza](#214-order-tábla-a-megrendelések-adatait-tartalmazza)
      - [2.1.5. OrderItem tábla: A megrendelések tételeit tartalmazza](#215-orderitem-tábla-a-megrendelések-tételeit-tartalmazza)
      - [2.1.6. Invoice tábla: A számlák adatait tartalmazza](#216-invoice-tábla-a-számlák-adatait-tartalmazza)
      - [2.1.7. InvoiceItem tábla: A számlák tételeit tartalmazza](#217-invoiceitem-tábla-a-számlák-tételeit-tartalmazza)
    - [2.2. Fejlesztendő területek a valós felhasználás pontosabb modellezésére](#22-fejlesztendő-területek-a-valós-felhasználás-pontosabb-modellezésére)
  - [3. Partíciók, indexek](#3-partíciók-indexek)
    - [3.1 Partícionálás](#31-partícionálás)
    - [3.2 Indexek](#32-indexek)
  - [4. Tárolt eljárások](#4-tárolt-eljárások)
    - [4.1. Tárolt eljárás a számla generálására a vásárlás adatai alapján](#41-tárolt-eljárás-a-számla-generálására-a-vásárlás-adatai-alapján)
    - [4.2. Tárolt eljárás a legtöbbet eladott könyvek lekérdezésére](#42-tárolt-eljárás-a-legtöbbet-eladott-könyvek-lekérdezésére)
    - [4.3. Tárolt eljárás a legtöbbet vásárlók lekérdezésére](#43-tárolt-eljárás-a-legtöbbet-vásárlók-lekérdezésére)
  - [5. Triggerek és függvények](#5-triggerek-és-függvények)
    - [5.1. Trigger a könyv készletének csökkentésére a rendelés kifizetésekor](#51-trigger-a-könyv-készletének-csökkentésére-a-rendelés-kifizetésekor)
    - [5.2. Megrendelés végösszegét frissítő trigger és függvények](#52-megrendelés-végösszegét-frissítő-trigger-és-függvények)
      - [5.2.1. Függvény a rendelés végösszegének és adótartalmának kiszámítására](#521-függvény-a-rendelés-végösszegének-és-adótartalmának-kiszámítására)
      - [5.2.2. Trigger a rendelés végösszegének és adótartalmának frissítésére az order táblában](#522-trigger-a-rendelés-végösszegének-és-adótartalmának-frissítésére-az-order-táblában)
    - [5.3. Trigger a számla generálására a rendelés kifizetésekor](#53-trigger-a-számla-generálására-a-rendelés-kifizetésekor)
  - [6. Lekérdezések](#6-lekérdezések)
    - [6.1. Legtöbbet eladott könyvek adatainak lekérdezése](#61-legtöbbet-eladott-könyvek-adatainak-lekérdezése)
    - [6.2. A legtöbb könyvet vásárolt vásárló adatainak lekérdezése](#62-a-legtöbb-könyvet-vásárolt-vásárló-adatainak-lekérdezése)
    - [6.3. Kosárban lévő könyvek adatainak lekérdezése](#63-kosárban-lévő-könyvek-adatainak-lekérdezése)
    - [6.4. Számlák tételes lekérdezése a vásárló és az áruház adataival](#64-számlák-tételes-lekérdezése-a-vásárló-és-az-áruház-adataival)
    - [6.5. Rendelések tételes lekérdezése egy adott országra és végösszeg-tartományra szűrve](#65-rendelések-tételes-lekérdezése-egy-adott-országra-és-végösszeg-tartományra-szűrve)
  - [7. Teljesítményelemzés](#7-teljesítményelemzés)
    - [7.1 Tesztadatok generálása](#71-tesztadatok-generálása)
    - [7.2 Mérés](#72-mérés)
      - [7.2.1. Optimalizálatlan lekérdezés](#721-optimalizálatlan-lekérdezés)
      - [7.2.2. Módosított lekérdezés szűkített eredményhalmazzal](#722-módosított-lekérdezés-szűkített-eredményhalmazzal)
    - [7.3. Az elemzés eredménye](#73-az-elemzés-eredménye)
      - [7.3.1. Az első lekérdezés elemzése](#731-az-első-lekérdezés-elemzése)
      - [7.3.2. A módosított lekérdezés elemzése](#732-a-módosított-lekérdezés-elemzése)
    - [7.4. Optimalizálási javaslatok](#74-optimalizálási-javaslatok)
      - [7.2.1. Az adatbázisban](#721-az-adatbázisban)
      - [7.2.2. A lekérdezésben](#722-a-lekérdezésben)
  - [Összegzés](#összegzés)


## 1. Bevezetés

* MVP egy online Könyvesbolt működésének modellezésére, a lehető legegyszerűbb adatbázis struktúrával.

## 2. Adatbázisterv
![image](https://github.com/user-attachments/assets/212a4bee-f5fc-47ce-84b1-fb0a26c824d6)


### 2.1. Táblák

#### 2.1.1. Store tábla: A könyvesbolt adatai és elérhetőségei

<table style="border: none">
<tr>
<td valign="top" width="350">

| Store |||
| -- | ----------- | ---------------------- |
| PK | store_id    | serial                 |
|    | name        | character varying(100) |
|    | description | character varying(100) |
|    | tax_id      | character varying(100) |
|    | address     | character varying(255) |
|    | phone       | integer                |
|    | email       | character varying(255) |
|    | url         | character varying(255) |

</td>
<td valign="top">

Jelenleg a számlakészítésnél van felhasználva, a későbbiekben viszont további üzletek hozzáadására is lehetőséget ad.

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TABLE store (
    store_id SERIAL NOT NULL PRIMARY KEY,
    name character varying(100) DEFAULT 'Bookshop'::character varying NOT NULL UNIQUE,
    description character varying(100),
    tax_id character varying(100) DEFAULT 0 NOT NULL,
    address character varying(255) NOT NULL,
    phone integer NOT NULL,
    email character varying(255) NOT NULL UNIQUE,
    url character varying(255)
);
```

</details>

---

#### 2.1.2. Book tábla: A könyvek adatait tartalmazza

<table style="border: none">
<tr>
<td valign="top" width="350">

| Book |||
| -- | ----------- | ---------------------- |
| PK | book_id     | serial                 |
|    | title       | character varying(255) |
|    | description | text                   |
|    | author      | character varying(255) |
|    | price       | money                  |
|    | stock       | integer                |
|    | url         | character varying(255) |

</td>
<td valign="top">


Az egyszerűség kedvéért az adott könyvhöz tartozó készlet (`stock`) is ebben a táblában van tárolva.
Értéke nem lehet kisebb mint 0.
Amennyiben több üzletet is kezelni szeretnénk, akkor szükséges lesz majd egy külön **Stock** táblába kiszervezni.

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TABLE book (
    book_id SERIAL NOT NULL PRIMARY KEY,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    author character varying(255) NOT NULL,
    price money NOT NULL,
    stock integer NOT NULL DEFAULT 0 CHECK (stock >= 0)
);
```

</details>

---

#### 2.1.3. Customer tábla: A vásárlók adatait tartalmazza

<table style="border: none">
<tr>
<td valign="top" width="350">

| Customer |||
| -- | ----------- | ---------------------- |
| PK | customer_id | serial                 |
|    | email       | character varying(255) |
|    | first_name  | character varying(100) |
|    | last_name   | character varying(100) |
|    | city        | character varying(100) |
|    | address     | character varying(100) |
|    | phone       | character varying(100) |
| PK | country     | character varying(100) |


</td>
<td valign="top">

Partícionálva ország (`country`) szerint, emiatt a `country` mező is az elsődleges kulcs része. 
Az `email` mező a partíciók létrehozásakor kap indexet és partíciónként lehet UNIQUE.

A vásárló elérhetőségeit és címét is tartalmazza. Ezeket ki lehet szervezni egy külön táblába, 
amennyiben több címadatot is meg akarunk adni az egyes vásárlóknak. (pl. meg akarjuk különböztetni a számlázási és szállítási címet)

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TABLE customer (
    customer_id SERIAL,
    email character varying(255) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    address character varying(100) NOT NULL,
    phone character varying(100),
    country character varying(100) NOT NULL,
    PRIMARY KEY (customer_id, country)
) PARTITION BY LIST (country);
```

</details>

---

#### 2.1.4. Order tábla: A megrendelések adatait tartalmazza

Tartozik hozzá egy **OrderItems** (`order_items`) tábla, ami a megrendelt tételeket tartalmazza.
Megrendelés státuszának lehetséges értékeit egy `order_status` típusú enum adja.

<table style="border: none">
<tr>
<td valign="top" width="350">

| Order |||
| --- | ----------- | ---------------------- |
| PK  | order_id    | serial                 |
| FK1 | store_id    | integer                |
| FK2 | customer_id | integer                |
|     | total       | money                  |
|     | tax         | money                  |
|     | status      | order_status           |
|     | created     | timestamp              |
|     | updated     | timestamp              |

</td>
<td valign="top">

| Státuszok    | |
| ------------ | --- |
| 'cart'       | a terméket a vásárló kosárba helyezte |
| 'unpaid'     | megrendelt, de még nem kifizetett rendelés |
| 'paid'       | kifizetett rendelés, ilyenkor automatikusan számla<br> is készül (trigger által indított tárolt eljárással) |
| 'processing' | elkezdődött a csomag összekészítése |
| 'shipped'    | a csomag feladásra került |
| 'delivered'  | a csomag kézbesítve |
| 'cancelled'  | a megrendelést visszamondták |
| 'returned'   | termék visszaküldve |
| 'refunded'   | vételár visszatérítve |

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TYPE order_status AS ENUM ('cart', 'unpaid', 'paid', 'processing', 'shipped', 'delivered', 'cancelled', 'returned', 'refunded');

CREATE TABLE "order" (
    order_id SERIAL NOT NULL PRIMARY KEY,
    store_id integer NOT NULL,
    customer_id integer NOT NULL,
    total money DEFAULT 0 NOT NULL,
    tax money DEFAULT 0 NOT NULL,
    status order_status DEFAULT 'cart'::order_status NOT NULL,
    created timestamp DEFAULT now() NOT NULL,
    updated timestamp
);
```

</details>

---

#### 2.1.5. OrderItem tábla: A megrendelések tételeit tartalmazza

<table style="border: none">
<tr>
<td valign="top" width="350">

| OrderItem |||
| ------ | ----------- | ---------------------- |
| PK/FK1 | order_id    | serial                 |
| PK/FK2 | book_id     | integer                |
|        | quantity    | integer                |


</td>
<td valign="top">

A könyvek táblát (`book`) kapcsolja össze a megrendelések táblájával (`order`) 
N:M relációt biztosítva közöttük. Az `order_id` és a `book_id` mezők közösen alkotják az elsődleges kulcsot, és egyben idegenkulcsok is.

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TABLE order_item (
    order_id integer NOT NULL REFERENCES "order"(order_id),
    book_id integer NOT NULL REFERENCES book(book_id),
    quantity integer NOT NULL,
    PRIMARY KEY (order_id, book_id)
);
```

</details>

---

#### 2.1.6. Invoice tábla: A számlák adatait tartalmazza

<table style="border: none">
<tr>
<td valign="top" width="350">

| Invoice |||
| --- | ----------- | ---------------------- |
| PK  | invoice_id  | serial                 |
| FK1 | order_id    | serial                 |
| FK2 | store_id    | integer                |
| FK3 | customer_id | integer                |
|     | total       | money                  |
|     | tax         | money                  |
|     | created     | timestamp              |

</td>
<td valign="top">

Tartozik hozzá egy **InvoiceItems** (`invoice_items`) tábla, ami a számla tételeit tartalmazza. Tartalma tárolt eljárás segítségével jön létre, amit trigger indít el, miután a megrendelés státusza `paid` lett.  Nincs teljes integritásban az adatbázis aktuális állapotával. A végösszeg és ÁFA értékei másolatok, a megrendelés kifizetésekori értéket őrzik meg.

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TABLE invoice (
    invoice_id SERIAL NOT NULL PRIMARY KEY,
    order_id integer NOT NULL REFERENCES "order"(order_id),
    store_id integer NOT NULL REFERENCES store(store_id),
    customer_id integer NOT NULL REFERENCES customer(customer_id),
    total money DEFAULT 0 NOT NULL,
    tax money DEFAULT 0 NOT NULL,
    created timestamp DEFAULT now() NOT NULL
);
```

</details>

---

#### 2.1.7. InvoiceItem tábla: A számlák tételeit tartalmazza

<table style="border: none">
<tr>
<td valign="top" width="350">

| InvoiceItem |||
| ------ | ----------- | ---------------------- |
| PK/FK1 | order_id    | serial                 |
| PK/FK2 | book_id     | integer                |
|        | quantity    | integer                |


</td>
<td valign="top">

A könyvek táblát (`book`) kapcsolja össze a számlák táblájával (`order`) 
N:M relációt biztosítva közöttük. (junction table) Az `invoice_id` és a `book_id` mezők közösen alkotják az elsődleges kulcsot, és egyben idegenkulcsok is. Nincs teljes integritásban az adatbázis aktuális állapotával. Az egységár (`invoice_price`) és a darabszám (`quantity`) másolatok, a megrendelés kifizetésekori értéket őrzik meg.

</td>
</tr>
</table>

<details>
<summary>SQL kód 🧾</summary>

```sql
CREATE TABLE invoice_item (
    invoice_id integer NOT NULL REFERENCES invoice(invoice_id),
    book_id integer NOT NULL REFERENCES book(book_id),
    quantity integer NOT NULL,
    invoice_price money NOT NULL,
	PRIMARY KEY (book_id, invoice_id)
);
```

</details>

---


### 2.2. Fejlesztendő területek a valós felhasználás pontosabb modellezésére

Bár a fentebb vázolt struktúra már elegendő a feladat megoldásához, de ha valós felhasználásra is alkalmassá akarnánk tenni, 
akkor az alábbi kiegészítésekre még biztosan szükség lenne:

* A Customer tábla helyett User tábla egy további "role" oszloppal, aminek az értéke "Customer" (a role oszlop pedig enum)
* Regisztráció és login (password hash tárolása a User táblában)
* Role tábla a különböző típusú felhasználók megkülönböztetésére (pl. "Admin" | "Customer" etc.)
* Address tábla a címadatok különálló kezeléséhez
* Szállítási és számlázási cím megkülönböztetése
* Szállítási módok megadása

* Célszerűbb lenne, ha az Invoice tábla json formátumban mentené el a számla adatokat, 
hogy a számla biztosan az eredeti állapotában legyen eltárolva.

* Külön Stock tábla a készletkezeléshez
* Categories tábla a Könyvek kategorizálásához
* Images tábla a könyvborítók tárolására

Esetleg még: Több üzlet kezelése saját raktárkészlettel. Így lehetne az üzletek között is szűrni az elérhető készletre.

## 3. Partíciók, indexek

### 3.1 Partícionálás

A vásárlói tábla (`customer`) partícionálásának alapjául végül az országra esett a választás. Életszerű lehet az adatbázist ez alapján felosztani. Mert így az adott partíciót akár az adott földrajzi területre eső edge szerverről is ki lehet szolgálni. (igaz, erre inkább már a shardolás ajánlott, de technikailag lehetséges partíciókkal is)
Az egyszerűség kedvéért nem készült külön `country` tábla az MVP-hez. Valós környezetben ez feltétlen ajánlott.

Az `email` mező a `customer` táblán eredetileg UNIQUE megkötéssel lett létrehozva. Viszont ez akadályozta a partícionálást, ezért ezt is fel kellett venni a partícionálásra használt oszlopok közé. Igaz, így már csak országon belül lehet egyedi az értéke, de egy felhasználó egyszerre csak egy országhoz tartozhat, így gyakorlatilag kizárható az ütközés lehetősége (feltételezve az adatbázis érvényes állapotát).

```sql
-- Partícionálás a customer táblán ország szerint
--
CREATE TABLE customer (
    customer_id SERIAL,
    ...
    country character varying(100) NOT NULL,
    PRIMARY KEY (customer_id, country),
    UNIQUE (email, country)
) PARTITION BY LIST (country);
```

A tesztadatokhoz három partíció készült: Magyarország, USA, Japán.

```sql
-- Partíciótáblák létrehozása
--
CREATE TABLE customer_usa PARTITION OF customer
FOR VALUES IN ('USA');

CREATE TABLE customer_hun PARTITION OF customer
FOR VALUES IN ('Hungary');

CREATE TABLE customer_jpn PARTITION OF customer
FOR VALUES IN ('Japan');
```

### 3.2 Indexek
A jobb teljesítmény érdekében mind a country, mind az email mezőre került index, amit automatikusan a partíciók is megkapnak.

```sql

-- Indexek a country mezőre a customer táblán
CREATE INDEX idx_customer_country ON customer (country);

-- Indexek az email mezőre a customer táblán
CREATE INDEX idx_customer_email ON customer (email);
```

## 4. Tárolt eljárások

### 4.1. Tárolt eljárás a számla generálására a vásárlás adatai alapján
A hozzá tartozó trigger által minden megrendelés-státuszváltozásnál lefut.

```pgsql
-- Tárolt eljárás a számla generálására a vásárlás adatai alapján
--
CREATE OR REPLACE PROCEDURE generate_invoice(
  IN order_id integer, 
  OUT invoice_id integer) AS $$
DECLARE
    invoice_id integer;
    store_id integer;
    customer_id integer;
    book_id integer;
    quantity integer;
    i_book_id integer;
    i_quantity integer;
    invoice_price money;
    grand_total money;
    tax money;
BEGIN
    SELECT "order".store_id, "order".customer_id, "order".total, "order".tax
      INTO store_id, customer_id, grand_total, tax
      FROM "order"
     WHERE "order".order_id = generate_invoice.order_id;
    
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
```

### 4.2. Tárolt eljárás a legtöbbet eladott könyvek lekérdezésére
```pgsql
-- Tárolt eljárás a legtöbbet eladott könyvek lekérdezésére
--
CREATE OR REPLACE PROCEDURE best_selling_books(
  IN start_date timestamp, 
  IN end_date timestamp, 
  IN "limit" integer, 
  OUT book_id integer, 
  OUT title character varying, 
  OUT author character varying, 
  OUT total_sold integer) AS $$
BEGIN
    SELECT invoice_item.book_id, book.title, book.author, SUM(quantity) AS total_sold
      INTO book_id, title, author, total_sold
      FROM invoice_item
      JOIN invoice USING (invoice_id)
      JOIN book USING (book_id)
     WHERE invoice.created BETWEEN best_selling_books.start_date AND best_selling_books.end_date
  GROUP BY invoice_item.book_id, book.title, book.author
  ORDER BY total_sold DESC
     LIMIT best_selling_books."limit";
  RAISE NOTICE 'Legtöbbet eladott könyvek lekérdezése kész.';
END;
$$ LANGUAGE plpgsql;
```

### 4.3. Tárolt eljárás a legtöbbet vásárlók lekérdezésére

```pgsql
-- Tárolt eljárás a legtöbbet vásárlók lekérdezésére
--
CREATE OR REPLACE PROCEDURE best_customers(IN start_date timestamp, IN end_date timestamp, IN "limit" integer, OUT customer_id integer, OUT first_name character varying, OUT last_name character varying, OUT total_spent numeric) AS $$
BEGIN
    SELECT invoice.customer_id, customer.first_name, customer.last_name, SUM(total) AS total_spent
      INTO customer_id, first_name, last_name, total_spent
      FROM invoice
      JOIN customer USING (customer_id)
     WHERE invoice.created BETWEEN best_customers.start_date AND best_customers.end_date
  GROUP BY invoice.customer_id, customer.first_name, customer.last_name
  ORDER BY total_spent DESC
     LIMIT best_customers."limit";
  RAISE NOTICE 'Legtöbbet vásárlók lekérdezése kész.';
END;
$$ LANGUAGE plpgsql;
```

## 5. Triggerek és függvények

### 5.1. Trigger a könyv készletének csökkentésére a rendelés kifizetésekor

```pgsql
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
```

### 5.2. Megrendelés végösszegét frissítő trigger és függvények

#### 5.2.1. Függvény a rendelés végösszegének és adótartalmának kiszámítására
```pgsql
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
```
#### 5.2.2. Trigger a rendelés végösszegének és adótartalmának frissítésére az order táblában
```pgsql
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
```

### 5.3. Trigger a számla generálására a rendelés kifizetésekor
Ez a trigger a feljebb már bemutatott `generate_invoice` tárolt eljárást hívja meg, a számla adatainak lementésére az **Invoice** táblába.

```pgsql
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
```

## 6. Lekérdezések
Néhány összetettebb lekérdezés bemutatása. További lekérdezések a [6_db_queries.sql](https://github.com/ARGVKW/DB-Bookshop/blob/main/6_db_queries.sql) fájlban találhatók.

### 6.1. Legtöbbet eladott könyvek adatainak lekérdezése

```pgsql
-- Legtöbbet eladott könyvek adatainak lekérdezése
SELECT book_id, title, author, price, stock, SUM(quantity) AS sold 
  FROM book
  JOIN order_item USING (book_id)
 GROUP BY book_id
 ORDER BY sold DESC;
```

### 6.2. A legtöbb könyvet vásárolt vásárló adatainak lekérdezése

```pgsql
-- A legtöbb könyvet vásárolt vásárló adatainak lekérdezése
SELECT customer_id, first_name, last_name, email, country, city, address, phone, SUM(quantity) AS bought 
  FROM customer 
  JOIN "order" USING (customer_id) 
  JOIN order_item USING (order_id)
 GROUP BY customer_id, first_name, last_name, email, country, city, address, phone 
 ORDER BY bought DESC;
```

### 6.3. Kosárban lévő könyvek adatainak lekérdezése

```pgsql
-- Kosárban lévő könyvek adatainak lekérdezése
SELECT book_id, title, author, price, stock, quantity, status
  FROM book
  JOIN order_item USING (book_id)
  JOIN "order" USING (order_id)
 WHERE status = 'cart';
```

### 6.4. Számlák tételes lekérdezése a vásárló és az áruház adataival

```pgsql
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
```

### 6.5. Rendelések tételes lekérdezése egy adott országra és végösszeg-tartományra szűrve
```pgsql
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
```

## 7. Teljesítményelemzés

### 7.1 Tesztadatok generálása

Az adatbázis az elemzés futtatásakor 100 000+ megrendelés, 20 000+ könyv és 10 000+ vásárló rekordot tartalmazott.
A megrendelésekhez tartozó tételek száma több mint 500 000. 

A vásárló tábla feltöltése 10 000 randomizált rekorddal
```pgsql
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
```

A rendelés tábla 100 000 randomizált rekorddal való feltöltése

```pgsql
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
```
A randomizált tesztadatok generálásához használt további lekérdezések megtalálhatók a [7_db_performance_analysis.sql](https://github.com/ARGVKW/DB-Bookshop/blob/main/7_db_performance_analysis.sql) fájlban.

### 7.2 Mérés

A teljesítményelemzéshez pedig az alábbi összetett lekérdezések lett alkalmazva.

#### 7.2.1. Optimalizálatlan lekérdezés

```sql
-- Megrendelések megjelenítése
--
EXPLAIN ANALYSE
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
 ORDER BY order_id, author;
```

#### 7.2.2. Módosított lekérdezés szűkített eredményhalmazzal
```pgsql
-- Megrendelések tételes lekérdezése egy adott országra és végösszeg-tartományra szűrve, 
-- oldalanként 20 rekordot megjelenítve
--
EXPLAIN ANALYSE
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
 LIMIT 100 OFFSET 0;
```

### 7.3. Az elemzés eredménye
#### 7.3.1. Az első lekérdezés elemzése
![image](https://github.com/user-attachments/assets/ed36e1c0-4228-4d15-bc3d-4f716daaadc9)

#### 7.3.2. A módosított lekérdezés elemzése
![image](https://github.com/user-attachments/assets/3db4cef9-9001-4e02-a8bd-7697f66a77ce)

### 7.4. Optimalizálási javaslatok

Az első lekérdezés végrehajtása az elemzés szerint több mint 1 másodpercig tartott (1228.462ms). Ez nagy részt a többszörös hash join utasításoknak és a több mezőre alkalmazott ORDER BY utasításnak is köszönhető. De legfőképp persze az 500 000+ lekérdezett sornak.

A második viszont ennek töredéke alatt 0.261 ezredmásodperc alatt futott le a viszonylag nagyra hagyott - 100 rekord/oldal - limit ellenére. De még 1000 rekord/oldal esetén is csupán 6.55 ezredmásodpercre volt szüksége, ami kiváló eredmény.


Nézzünk hát mi áll ennek a hátterében és még néhány további lehetőséget a teljesítmény javítására.

#### 7.2.1. Az adatbázisban
* Indexekből már elegendő van mind a normál, mind a partíciós táblákon. Ez látszik is a lekérdezések végrehajtási idején, és abból is hogy nincs sehol Sequential Scan. Minden esetben Index Scan történik, tehát ki vannak használva az indexek.

* Az Evictions és Overflows értéke mindenhol 0, ami arra enged következtetni, hogy cache is elegendő.

* Látható, hogy a partícionálásnak is van némi ára felhasznált memória terén, de a cost elhanyagolható (Append művelet).

* A legnagyobb költsége az Incremental Sort (ORDER BY miatt) és a Nested Loop (hash join miatt) műveleteknek van. Ezeken elsősorban a lekérdezés optimalizálásával segíthetünk; vagy View, esetleg Materialized View alkalmazásával.
  
* A "Részösszeg" alias-t előállító szorzás művelet kiváltása egy új oszloppal az `order_item` táblán:
  * `subtotal` mező hozzáadása az `order_item` táblához,
  * a `subtotal` értéke rögtön az `order_item` tábla frissítésekor kiszámítható, mert a szükséges adatok (`quantity` és `price`) rendelkezésre állnak. Triggerre nincs szükség.


* `order` tábla partícionálása státusz szerint 
  (Így pl. a teljesült rendelések külön táblába kerülhetnek, amiben csak akkor kell keresni, ha konkrétan ezekre az adatokra van szükség)

* Normalizáció a country mezőre (külön country tábla) -> NF3 normál forma 
  (ez az atomicitáson és a tárhelyigényen javít, a teljesítményen nem igazán, viszont hasznos lehet, ha máshol is fel akarjuk használni a country adatokat)

#### 7.2.2. A lekérdezésben
* Redundancia csökkentése a JOIN utasítások minimalizálásával
	* Átszervezni a lekérdezést, hogy az ismétlődő adatok (eladó, vásárló, végösszeg) külön lekérdezésbe kerüljenek
* WHERE feltétel hozzádása. Pl. adott országra, státuszra stb. szűrve csökkenteni a lekérdezés méretét.
* LIMIT és OFFSET megadása, hogy ne az összes rekordot kérdezzük le egyszerre. 
  Az offset változtásával pedig végig léptethetünk az adatokon. Erre építve a UI-on lapozó funkciót hozhatunk létre (pagination)

## Összegzés
Belátható, hogy rendkívül fontos a jól megtervezett adatbázis ahhoz, hogy nagy terhelésű rendszert építhessünk rá. Viszont az is belátható, hogy még egy egyszerűbb felépítésű adatbázis - mint a jelen MVP - lekérdezése is nagyságrendekkel gyorsulhat, ha jól választjuk meg a lekérdezés feltételeit.
