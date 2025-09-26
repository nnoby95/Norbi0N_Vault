sudo -u postgres psql -d vault << 'EOF'
INSERT INTO feature.translation (translation_id, key, value) VALUES
(2, 448, 'jan., febr., márc., ápr., máj., jún., júl., aug., szept., okt., nov., dec.'),
(2, 449, 'ma ekkor: {time}'),
(2, 450, 'holnap ekkor: {time}'),
(2, 451, '{time}, érkezés ekkor: {date}'),
(2, 452, '{date} napon {time} órakor'),
(2, 453, '{hour}:{minute}:{second}:{millisecond}, ebben az időben: {day}.{month}.{year}'),
(2, 454, 'nap'),
(2, 455, 'hr'),
(2, 456, 'min'),
(2, 457, 'sec'),
(2, 458, 'napok'),
(2, 459, 'óra'),
(2, 460, 'mins'),
(2, 461, 'secs'),
(2, 554, '{month} {day}, {year} {hour}:{minute}:{second}:{millis}'),
(2, 557, '{hour}:{minute}:{second}:{millis}

                {hour}:{minute}:{second}

                {hour}:{minute}'),
(2, 558, '{monthName} {day}, {year}

                {day}/{month}/{year}

                {day}.{month}.'),
(2, 559, '{monthName} {day}, {hour}:{minute}

                {monthName} {day},{year} {hour}:{minute}

                {hour}:{minute}:{second}:{millisecond} on {day}:{month}:{year}')
ON CONFLICT (translation_id, key) DO UPDATE SET value = EXCLUDED.value;
EOF
