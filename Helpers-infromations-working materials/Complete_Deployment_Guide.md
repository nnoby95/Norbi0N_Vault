# Complete Vault Deployment Guide for Hungarian Tribal Wars

## 🎯 Overview
This guide deploys the Vault application on a fresh Linode server with Hungarian (`klanhaboru.hu`) support, avoiding the StackScript issues.

## 📋 Prerequisites
- Fresh Ubuntu 22.04 LTS Linode server
- Domain name configured (`vault.norbi0n.online`) pointing to server IP
- SSH access to the server

---

## 🚀 Step-by-Step Deployment

### Step 1: Initial Server Setup
```bash
# SSH into your server
ssh root@YOUR_SERVER_IP

# Update system
apt update && apt upgrade -y

# Install essential packages
apt install -y git curl wget nginx postgresql postgresql-contrib ufw fail2ban

# Setup firewall
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable
```

### Step 2: Install .NET 8
```bash
# Add Microsoft package repository
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install .NET 8
apt update
apt install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0
```

### Step 3: Clone and Setup Application
```bash
# Create application directory
mkdir -p /opt/vault
cd /opt/vault

# Clone your repository
git clone https://github.com/nnoby95/Norbi0N_Vault.git src

# Build the application
cd src/app
dotnet restore
dotnet build --configuration Release
dotnet publish TW.Vault.App -c Release -o /opt/vault/app
dotnet publish TW.Vault.Manage -c Release -o /opt/vault/manage
dotnet publish TW.Vault.MapDataFetcher -c Release -o /opt/vault/mapfetcher
```

### Step 4: Setup PostgreSQL Database
```bash
# Switch to postgres user
sudo -u postgres psql

# Create database and user (in psql)
CREATE DATABASE vault;
CREATE USER vaultuser WITH ENCRYPTED PASSWORD 'your_secure_password_here';
GRANT ALL PRIVILEGES ON DATABASE vault TO vaultuser;
ALTER USER vaultuser CREATEDB;
\q

# Run database migrations
cd /opt/vault/manage
export ConnectionStrings__DefaultConnection="Host=localhost;Database=vault;Username=vaultuser;Password=your_secure_password_here"
dotnet TW.Vault.Manage.dll migrate
```

### Step 5: Configure Application Settings
```bash
# Create production config for main app
cat > /opt/vault/app/appsettings.Production.json << 'EOF'
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=vault;Username=vaultuser;Password=your_secure_password_here"
  },
  "Behavior": {
    "DisableFakeScript": false
  }
}
EOF

# Create production config for manage app
cat > /opt/vault/manage/appsettings.Production.json << 'EOF'
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=vault;Username=vaultuser;Password=your_secure_password_here"
  }
}
EOF

# Create production config for map fetcher
cat > /opt/vault/mapfetcher/appsettings.Production.json << 'EOF'
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=vault;Username=vaultuser;Password=your_secure_password_here"
  }
}
EOF
```

### Step 6: Configure Systemd Services
```bash
# Main web application service
cat > /etc/systemd/system/twvault-app.service << 'EOF'
[Unit]
Description=TW Vault Web Application
After=network.target

[Service]
Type=notify
ExecStart=/usr/bin/dotnet /opt/vault/app/TW.Vault.App.dll
Restart=always
RestartSec=5
KillSignal=SIGINT
SyslogIdentifier=twvault-app
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://localhost:5000
WorkingDirectory=/opt/vault/app

[Install]
WantedBy=multi-user.target
EOF

# Management service
cat > /etc/systemd/system/twvault-manage.service << 'EOF'
[Unit]
Description=TW Vault Management Service
After=network.target

[Service]
Type=notify
ExecStart=/usr/bin/dotnet /opt/vault/manage/TW.Vault.Manage.dll
Restart=always
RestartSec=5
KillSignal=SIGINT
SyslogIdentifier=twvault-manage
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://localhost:5020
WorkingDirectory=/opt/vault/manage

[Install]
WantedBy=multi-user.target
EOF

# Map fetcher service
cat > /etc/systemd/system/twvault-map-fetcher.service << 'EOF'
[Unit]
Description=TW Vault Map Data Fetcher
After=network.target

[Service]
Type=notify
ExecStart=/usr/bin/dotnet /opt/vault/mapfetcher/TW.Vault.MapDataFetcher.dll
Restart=always
RestartSec=5
KillSignal=SIGINT
SyslogIdentifier=twvault-map-fetcher
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://localhost:5030
WorkingDirectory=/opt/vault/mapfetcher

[Install]
WantedBy=multi-user.target
EOF

# Set permissions and enable services
chown -R www-data:www-data /opt/vault
systemctl daemon-reload
systemctl enable twvault-app twvault-manage twvault-map-fetcher
systemctl start twvault-app twvault-manage twvault-map-fetcher
```

### Step 7: Configure Nginx
```bash
# Remove default site
rm -f /etc/nginx/sites-enabled/default

# Create Vault site configuration
cat > /etc/nginx/sites-available/vault << 'EOF'
server {
    listen 80;
    server_name vault.norbi0n.online;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    location /manage {
        proxy_pass http://localhost:5020;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Enable site and restart nginx
ln -s /etc/nginx/sites-available/vault /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

### Step 8: Install SSL Certificate (Certbot)
```bash
# Install certbot via apt (avoiding snapd issues)
apt update
apt install -y certbot python3-certbot-nginx

# Get SSL certificate
certbot --nginx -d vault.norbi0n.online --non-interactive --agree-tos -m your-email@example.com

# Verify auto-renewal
certbot renew --dry-run
```

### Step 9: Configure Hungarian Support
```bash
# Add Hungarian server configuration
cd /opt/vault/manage
dotnet TW.Vault.Manage.dll configure -extraTLD klanhaboru.hu -fetch-all -accept
```

### Step 10: Import Hungarian Translations
```bash
# Copy the Hungarian import files to server
# (Upload Hungarian-Import-Commands folder to /tmp/)

# Import in order:
# 1. Critical date/time formats first
/tmp/Hungarian-Import-Commands/hu_critical.sh

# 2. Then all other translations
/tmp/Hungarian-Import-Commands/hu1.sh
/tmp/Hungarian-Import-Commands/hu2.sh
# ... continue with hu3.sh through hu13.sh

# Verify import
sudo -u postgres psql -d vault -c "SELECT COUNT(*) FROM feature.translation WHERE translation_id = 2;"

# Restart services to apply translations
systemctl restart twvault-app twvault-manage twvault-map-fetcher
```

### Step 11: Final Verification
```bash
# Check service status
systemctl status twvault-app twvault-manage twvault-map-fetcher

# Check ports
ss -tlnp | grep -E ':(5000|5020|5030|80|443)'

# Test web access
curl -I https://vault.norbi0n.online
```

---

## 🔧 Troubleshooting

### Common Issues:
1. **Services not starting**: Check logs with `journalctl -u twvault-app -f`
2. **Database connection**: Verify PostgreSQL is running and credentials are correct
3. **SSL issues**: Ensure domain DNS is properly configured
4. **Permission errors**: Run `chown -R www-data:www-data /opt/vault`

### Useful Commands:
```bash
# View logs
journalctl -u twvault-app -f
journalctl -u nginx -f

# Restart everything
systemctl restart twvault-app twvault-manage twvault-map-fetcher nginx

# Database access
sudo -u postgres psql vault
```

---

## ✅ Success Criteria
- ✅ All 3 services running (`systemctl status`)
- ✅ SSL certificate installed (https://vault.norbi0n.online works)
- ✅ 515+ Hungarian translations imported
- ✅ Hungarian date parsing working (no JavaScript errors)
- ✅ Can register and use Vault with klanhaboru.hu

**🇭🇺 Your Hungarian Tribal Wars Vault is ready!** 🚀
