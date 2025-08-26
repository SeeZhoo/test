#!/bin/bash

DOMAIN="hi.seezhoo.my.id"
WWW_DOMAIN="www.hi.seezhoo.my.id"
NGINX_CONF="/etc/nginx/sites-available/default"
BACKUP_CONF="/etc/nginx/sites-available/default.bak.$(date +%s)"

echo "[1/6] Backup konfigurasi Nginx..."
cp $NGINX_CONF $BACKUP_CONF

echo "[2/6] Menonaktifkan SSL sementara..."
sed -i '/ssl_certificate/d' $NGINX_CONF
sed -i '/ssl_certificate_key/d' $NGINX_CONF
sed -i 's/listen 443 ssl;/# listen 443 ssl;/' $NGINX_CONF

echo "[3/6] Restart Nginx..."
nginx -t && systemctl restart nginx || { echo "Nginx gagal restart. Periksa konfigurasi."; exit 1; }

echo "[4/6] Mendapatkan sertifikat baru..."
certbot certonly --standalone -d $DOMAIN -d $WWW_DOMAIN || { echo "Certbot gagal."; exit 1; }

echo "[5/6] Mengaktifkan SSL kembali..."
CERT_PATH="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
KEY_PATH="/etc/letsencrypt/live/$DOMAIN/privkey.pem"
sed -i "/server_name $DOMAIN $WWW_DOMAIN;/a \
    ssl_certificate $CERT_PATH;\n    ssl_certificate_key $KEY_PATH;\n    listen 443 ssl;" $NGINX_CONF

echo "[6/6] Restart Nginx dengan SSL aktif..."
nginx -t && systemctl restart nginx || { echo "Nginx gagal restart setelah SSL diaktifkan."; exit 1; }

echo "Selesai! SSL untuk $DOMAIN sudah aktif."
