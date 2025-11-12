#!/bin/bash
set -e

# create FTP user
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
else
    echo "[FTP] User $FTP_USER already exists, skipping creation"
fi
# create FTP own folder and change permission
echo "[FTP] create FTP own folder and change permission"
mkdir -p /home/vsftpd
chown -R "$FTP_USER":"$FTP_USER" /home/vsftpd
mkdir -p /var/run/vsftpd/empty

# modify vsftpd setting
cat <<EOF > /etc/vsftpd.conf
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
pasv_enable=YES
pasv_min_port=21000
pasv_max_port=21010
chroot_local_user=YES
allow_writeable_chroot=YES
user_sub_token=\$USER
local_root=/home/\$USER
EOF

echo "[FTP] Starting vsftpd in foreground..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
