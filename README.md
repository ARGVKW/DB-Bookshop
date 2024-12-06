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
![image](https://github.com/user-attachments/assets/bcd91076-d8de-45fd-9822-25968bc24cde)


### Optimalizálási javaslatok

Látható, hogy a teljes lekérdezés több mint 5 másodpercig futott.

Néhány javaslat a teljesítmány javítására.

Az adatbázisban:
* az `order total` alias-t előállító a subquery kiváltása egy új oszloppal az `order` táblán:
  * `total` oszlop felvétele az `order` táblára
  * trigger létrehozása, ami az `order_item` tábla update műveleteire frissíti hozzátartozó `order.total` mezőt, 
* `order` tábla partícionálása státusz szerint 
  (Így pl. a teljesült rendelések külön táblába kerülhetnek, amiben csak akkor kell keresni, ha konkrétan ezekre az adatokra van szükség)
* Normalizáció a country mezőre (külön country tábla) -> NF3 normál forma 
  (ez az atomicitáson és a tárhelyigényen javít, a teljesítményen nem igaz, viszont hasznos lehet, ha máshol is fel akarjuk használni a country adatokat)

A lekérdezésben
* Redundancia csökkentése a JOIN utasítások minimalizálásával
	* Átszervezni a lekérdezést hogy az ismétlődő adatok (eladó, vásárló, végösszeg) külön lekérdezésbe kerüljenek
