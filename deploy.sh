#!/bin/bash
# Script Deploy Website HTML/JS ke VPS

# === KONFIGURASI ===
REPO_URL="https://github.com/username/repo.git"  # Ganti dengan URL repo kamu
WEB_DIR="/var/www/html"

echo "=== [1/4] Update sistem dan install paket pendukung ==="
sudo apt update && sudo apt install -y git nginx curl

echo "=== [2/4] Clone repository dari GitHub ==="
sudo rm -rf $WEB_DIR/*
sudo git clone $REPO_URL $WEB_DIR

echo "=== [3/4] Atur izin folder ==="
sudo chown -R www-data:www-data $WEB_DIR

echo "=== [4/4] Restart Nginx ==="
sudo systemctl restart nginx

echo "=== SELESAI! ==="
echo "Website aktif di: http://$(curl -s ifconfig.me)"
