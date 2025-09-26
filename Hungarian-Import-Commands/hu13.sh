sudo -u postgres psql -d vault << 'EOF'
INSERT INTO feature.translation (translation_id, key, value) VALUES
(2, 568, 'A(z) Vault semmilyen személyes infromációt nem gyüjt az eszközdről, csupán a klánháborúban (röviden TW) elérhető adatokat nyeri ki. Ezen adatok a következőek:  Játékos neved (játékos felhasználód ID-je), a klánod neve (klánod ID-je), Térkép és csapat adatok.   A(z) Vault által összegyüjtött adatok a SAJÁT eszközöd lokális tárolójában kerülnek eltárolásra. A TW korlátozza a személyes online adataid küldését harmadik fél számára, ezért a Vault a SAJÁT lokális tárolódat használja az adatok feltötéséhez! A beleegyezéseddel elfogadod, hogy a játékbeli online adataidat a Vault elküdje a szerverre!')
ON CONFLICT (translation_id, key) DO UPDATE SET value = EXCLUDED.value;
EOF
