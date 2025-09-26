sudo -u postgres psql -d vault << 'EOF'
INSERT INTO feature.translation (translation_id, key, value) VALUES
(2, 285, 'Nukes'),
(2, 286, 'Fangs'),
(2, 287, 'Erősítés'),
(2, 288, 'Védelem'),
(2, 289, '# Védőcsapatok'),
(2, 290, 'Faluban'),
(2, 291, '(Backline) faluban'),
(2, 292, 'Úton'),
(2, 293, 'Támogatás'),
(2, 294, 'Magas pontszámok'),
(2, 295, 'Hiba történt a ranglista lekérése közben.'),
(2, 296, 'Ranglista'),
(2, 297, 'Támgotatás'),
(2, 298, 'Jogi nyilatkozatok és feltételek'),
(2, 299, 'Ez az eszköz nem az InnoGames támogatásával vagy fejlesztésével készült.'),
(2, 300, 'A Vault-hoz küldött összes adat és kérés biztonsági okokból naplózásra kerül. Ez kizárólag a következő információkra korlátozódik:

                Authetnikációs token, játékos ID, klán ID, kért végpont, és a tranzakció időpontja.

                A szkript által gyűjtött információk soha nem kerülnek megosztásra harmadik felekkel vagy jogosulatlan törzsekkel/játékosokkal.'),
(2, 301, 'Eszközök'),
(2, 302, 'Fake Script'),
(2, 303, 'Dinamikus Fake Scripts'),
(2, 304, 'Játékosok'),
(2, 305, 'Klánok'),
(2, 306, 'Kontinensek'),
(2, 307, 'Min koordináták'),
(2, 308, 'Max koordináták'),
(2, 310, 'Távolság középtől'),
(2, 311, 'mezők-től'),
(2, 312, 'Szerezd meg a koordinátákat'),
(2, 314, 'Találat: {numTimings} időzítés {numNukes} visszatérő nuke támadáshoz ({numShown} )'),
(2, 315, 'Find Backtimes'),
(2, 316, 'Folyamatban... (Ez eltarthat egy ideig)'),
(2, 318, 'Szerezd meg az összes elérhető backtime tervet az ellenséges nuke támadásokhoz a Vault-ban feltöltött csapatok felhasználásával.'),
(2, 319, 'Töltsd fel a csapataidat gyakran a legpontosabb időzítések érdekében!'),
(2, 320, 'Minimális visszatérő egység'),
(2, 321, 'Minimum támadás méret:'),
(2, 322, '% of a full nuke'),
(2, 323, 'Max utazási idő'),
(2, 324, 'Időzítések maximális száma:')
ON CONFLICT (translation_id, key) DO UPDATE SET value = EXCLUDED.value;
EOF
