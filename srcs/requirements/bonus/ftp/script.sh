#!/bin/bash
set -e

# Create FTP user if not exists
id -u "${FTP_USER}" &>/dev/null || useradd -m "${FTP_USER}"
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

# Make sure WordPress dir is owned by FTP user
mkdir -p /var/www/html
chown -R "${FTP_USER}:${FTP_USER}" /var/www/html

# Secure chroot dir (must exist with 755 perms)
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

echo "[INFO] Starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
