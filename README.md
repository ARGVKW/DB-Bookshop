# [WIP] DB-Bookshop
B-GY-DBSERV

* MVP egy online Könyvesbolt működésének szimulálására, a lehető legegyszerűbb adatbázis struktúrával.

## Adatbázisterv
![image](https://github.com/user-attachments/assets/7808d40e-7537-47c8-b166-6c9f6f6b7853)

### Fejlesztendő területek a valós felhasználás pontosabb modellezésére:

* A Customer tábla helyett User tábla egy további "role" oszloppal aminek az értéke "Customer" (a role oszlop pedig enum)
* Regisztráció és login (password hash tárolása a User táblában)
* Role tábla a különböző típusú felhasználók megkülönböztetésére (pl. "Admin" | "Customer" etc.)
* Address tábla a címadatok különálló kezeléséhez
* Szállítási és számlázási cím megkülönböztetése

* Célszerűbb lenne ha az Invoice tábla json formátumban menetené el a számlaadatokat, 
hogy a számla biztosan az eredeti állapotában legyen eltárolva.

* Külön Stock tábla a készletkezeléshez
* Categories tábla a Könyvek kategorizálásához
* Images tábla a könyvborítók tárolására

Esetleg még: Több üzlet kezelése saját raktárkészlettel. Így lehetne az üzletek között is szűrni az elérhető készletre.

## Teljesítményelemzés

A teljesítményelemzéshez az alábbi összetett lekérdezés lett alkalmazva. Többszörös JOIN és beágyazott lekérdezéssel.
Az adatbázis az elemzés futtatásakor 100 000+ megrendelés, 20 000+ könyv és 20 000+ vásárló rekordot tartalmazott.

```
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
```

Az elemzés eredménye:
![image](https://github.com/user-attachments/assets/c67acab8-6eb0-45ed-90e7-86beb665fcd9)

### Optimalizálási javaslatok

Látható, hogy a lekérdezés majdnem 2 másodpercig futott.

Javaslatok a teljesítmány javítására:
* Normalizáció a country mezőre (külön country tábla)
* Order tábla partícionálása státusz szerint (a teljesült rendelések így külön táblába kerülhetnek)
* ...