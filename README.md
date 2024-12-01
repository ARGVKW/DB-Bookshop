# [WIP] DB-Bookshop
B-GY-DBSERV

MVP egy online Könyvesbolt működésének szimulálására, a lehető legegyszerűbb adatbázis struktúrával.

![image](https://github.com/user-attachments/assets/7808d40e-7537-47c8-b166-6c9f6f6b7853)

Fejlesztendő területek a valós felhasználás pontosabb modellezésére:

A Customer tábla helyett User tábla egy további "role" oszloppal aminek az értéke "Customer" (a role oszlop pedig enum)
Regisztráció és login (password hash tárolása a User táblában)
Role tábla a különböző típusú felhasználók megkülönböztetésére (pl. "Admin" | "Customer" etc.)
Address tábla a címadatok különálló kezeléséhez
Szállítási és számlázási cím megkülönböztetése

Célszerűbb lenne ha az Invoice tábla json formátumban menetené el a számlaadatokat, 
hogy a számla biztosan az eredeti állapotában legyen eltárolva.

Külön Stock tábla a készletkezeléshez
Categories tábla a Könyvek kategorizálásához

Esetleg még: Több üzlet kezelése saját raktárkészlettel. Így lehetne az üzletek között is szűrni az elérhető készletre.
