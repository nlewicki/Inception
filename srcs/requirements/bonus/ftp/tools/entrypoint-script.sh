#!/bin/bash

FTP_USER=$(cat /run/secrets/ftp_user)
FTP_PASS=$(cat /run/secrets/ftp_password)

if ! id "$FTP_USER" &>/dev/null; then
    mkdir -p /var/run/vsftpd/empty #vsftpd needs this dir as root dir for users temporarily to start correctly (because it needs to be non writable)
    chmod 555 /var/run/vsftpd/empty #then it redirect the root dir of users to /var/www/html

    echo "Creating FTP user: $FTP_USER"
    useradd -m "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd

    usermod -aG www-data "$FTP_USER"
else
    echo "User $FTP_USER already exists, skipping creation."
fi

chmod -R 775 /var/www/html

echo "Starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf