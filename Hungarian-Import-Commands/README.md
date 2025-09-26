# Hungarian Translation Import Guide

## 🎯 Purpose & Logic
This guide imports **515+ Hungarian translations** for the Vault application to support Hungarian Tribal Wars (`klanhaboru.hu`). The translations are split into small batches to avoid PostgreSQL command length limits and shell parsing issues.

## 📋 Step-by-Step Import Process

### Step 1: SSH into Server
```bash
ssh root@1.1.1.1.1
```

### Step 2: Import Critical Date/Time Translations First
**Start with the most important file:**
```bash
# Copy and paste the contents of hu_critical.sh
sudo -u postgres psql -d vault << 'EOF'
INSERT INTO feature.translation (translation_id, key, value) VALUES
(2, 448, 'jan., febr., márc., ápr., máj., jún., júl., aug., szept., okt., nov., dec.'),
...
EOF
```
**Why first?** This contains Hungarian month abbreviations that fix JavaScript date parsing errors.

### Step 3: Import Main Translations (in order)
Copy and paste each file's content in this exact order:

1. **hu1.sh** - Keys 2-40 (Core UI translations)
2. **hu2.sh** - Keys 41-80 (Including fixed key 67 with parentheses)  
3. **hu3.sh** - Keys 81-120 (More core translations)
4. **hu4.sh** - Keys 121-160
5. **hu5.sh** - Keys 161-200
6. **hu6.sh** - Keys 201-284
7. **hu7.sh** - Keys 285-324
8. **hu8.sh** - Keys 325-377
9. **hu9.sh** - Keys 378-417
10. **hu10.sh** - Keys 418-479
11. **hu11.sh** - Keys 480-527
12. **hu12.sh** - Keys 528-567
13. **hu13.sh** - Key 568 (Final privacy disclaimer)

### Step 4: Verify Import
```bash
sudo -u postgres psql -d vault -c "SELECT COUNT(*) FROM feature.translation WHERE translation_id = 2;"
```
**Expected result:** 515+ translations

### Step 5: Restart Services
```bash
systemctl restart twvault-app.service twvault-manage.service twvault-map-fetcher.service
```

## 🛠️ Technical Logic

**Why Split into Small Files?**
- Avoids shell command length limits (argument list too long)
- Prevents PostgreSQL query size limits
- Makes troubleshooting easier if one batch fails
- Each file contains ~30-40 translations max

**Translation Strategy:**
- `translation_id = 2` = Hungarian language
- Uses exact translations from tested `hu_trans.csv` file
- Includes `ON CONFLICT DO UPDATE` for safe re-imports
- Critical date formats fix Hungarian month parsing (`aug.`, `szept.`, etc.)

## 🇭🇺 Result
Hungarian Tribal Wars users will see the interface in Hungarian, and date parsing will work correctly with Hungarian month abbreviations!