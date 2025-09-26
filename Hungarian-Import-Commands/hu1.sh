sudo -u postgres psql -d vault << 'EOF'
INSERT INTO feature.translation (translation_id, key, value) VALUES
(2, 2, 'Nyisd meg a Vault-ot'),
(2, 3, 'Érkezési idő'),
(2, 4, 'Időpont'),
(2, 5, 'Ez a szkript csak prémium fiókkal használható!'),
(2, 6, 'Ez az első alkalom, hogy futtatod a szkriptet – kérlek, olvasd el az alábbi ADATGYŰJTÉSI feltételeket.


                Ez a szkript a Vault interfészeként szolgál, amely egy privát eszköz a Klánháború adatainak gyűjtésére.

                 Minden adat a saját lokális tárolódban kerül mentésre, és teljes mértékben te döntöd el, hogy megosztod-e a szerverrel vagy sem. A naplózott információk kizárólag az alábbiakra korlátozódnak:
                - Hitelesítési token
                - Játékos ID
                - Klán ID
                - Lekért végpont
                - Tranzakció időpontja

                A szkript által gyűjtött információk soha nem kerülnek megosztásra harmadik felekkel vagy illetéktelen klánokkal/játékosokkal.

                A feltételeket később is megtekintheted a szkript futtatása után. Ha nem fogadod el azokat, egyszerűen ne futtasd a szkriptet újra.


                Elfogadod ezeket a feltételeket?'),
(2, 7, 'Köszönjük, kérjük, futtassa újra a szkriptet a használat megkezdéséhez.'),
(2, 8, 'A scipt nem lesz futtatva!'),
(2, 9, 'A Vault nemrég frissült, néhány adatot újra kell töltenie.'),
(2, 10, 'BB-kód készítése visszaidőzítéshez'),
(2, 11, 'Régóta nem töltött fel adatot, nem használhatja a visszaidőzítő szkriptet, amíg ezt meg nem teszi. Töltse fel adatait, majd frissítse az oldalt, és futtassa újra ezt a szkriptet.'),
(2, 12, 'Parancsok'),
(2, 13, 'Bejövő támadások'),
(2, 14, 'Jelentések'),
(2, 15, 'Egységek'),
(2, 16, 'Fel kell töltened:'),
(2, 17, 'Hiba keletkezett..'),
(2, 18, 'Nincsenek elérhető parancsok'),
(2, 19, 'Nincs elérhető adat'),
(2, 20, 'Csapatok'),
(2, 21, 'Faluból küldve'),
(2, 22, 'Időpont'),
(2, 23, 'Időpont'),
(2, 24, 'Szükséges csapatok'),
(2, 25, 'Vault'),
(2, 26, 'Ez a Vault. Győződj meg róla, hogy feltöltöd a jelentéseidet stb. a Feltöltés fülön. Futtasd ezt a szkriptet a Térképen vagy a Bejövő támadások oldalon, hogy láthass mindent, amit a Vault kínál.'),
(2, 27, 'Kész'),
(2, 28, 'A jelenlegi feltöltések a felugró ablak bezárása után is folytatódnak.'),
(2, 29, '{numIncs} bejövő támadás még nem lett feltöltve a Vaultba, ezért nem kap címkét!'),
(2, 30, 'Már régóta nem töltöttél fel adatot, ezért a címkézés addig nem használható, amíg nem töltesz fel újat.'),
(2, 31, 'Megjegyzés – ez a funkció KÍSÉRLETI jellegű, ezért előfordulhat, hogy nem pontos!'),
(2, 32, 'Látható bejövő támadások feltöltése'),
(2, 33, 'Kód'),
(2, 34, 'Részletek'),
(2, 35, 'Legvalószínűbb egységtípus (a címkéd alapján vagy automatikusan számítva)'),
(2, 36, 'Egy közülük: Fake, Nuke'),
(2, 37, '% A faluban ismert teljes nuke százaléka, pl. 89% vagy ?%'),
(2, 38, 'A faluban ismert támadó népesség, pl. 19.2k vagy ?k'),
(2, 39, '% A parancs elküldésekor a faluba visszatérő ismert teljes nuke százaléka, pl. 89% vagy ?%'),
(2, 40, 'A parancs elküldésekor a faluba visszatérő ismert támadó népesség, pl. 19.2k vagy ?k')
ON CONFLICT (translation_id, key) DO UPDATE SET value = EXCLUDED.value;
EOF
