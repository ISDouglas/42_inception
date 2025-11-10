#!/bin/bash
set -e
# debug mode
#set -ex

WORKDIR=/var/www/html

# ----------------------------
# Fix ownership if needed
# ----------------------------
if [ "$(stat -c '%U' $WORKDIR)" != "www-data" ]; then
    echo "[WordPress] Fixing directory ownership..."
    chown -R www-data:www-data $WORKDIR || true
fi

# -------------------------------------
# Add domain to /etc/hosts
# -------------------------------------
echo "127.0.0.1 ${DOMAIN_NAME}" >> /etc/hosts
echo "127.0.0.1 www.${DOMAIN_NAME}" >> /etc/hosts

# Read passwords
DB_PASSWORD=$(cat /run/secrets/db_pw)
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/credentials_pw)
WP_SECONDARY_PASSWORD=$(cat /run/secrets/credentials_second_pw)
# ----------------------------
# Check environment variables
# ----------------------------
: "${DB_HOST:?DB host not defined}"
: "${DB_NAME:?DB name not defined}"
: "${DB_USER:?DB user not defined}"
: "${DB_PASSWORD:?DB password file not defined}"
: "${WORDPRESS_ADMIN_USER:?WP admin user not defined}"
: "${WORDPRESS_ADMIN_PASSWORD:?WP admin password file not defined}"
: "${WORDPRESS_ADMIN_EMAIL:?WP admin email not defined}"
: "${WP_SECONDARY_USER:?Secondary user not defined}"
: "${WP_SECONDARY_PASSWORD:?Secondary password file not defined}"
: "${WP_SECONDARY_EMAIL:?Secondary email not defined}"


# ----------------------------
# Wait for MariaDB to be available
# ----------------------------
echo "[WordPress] Waiting for database $DB_HOST..."
until mysqladmin ping -h"$DB_HOST" --silent; do
    sleep 2
done
echo "[WordPress] Database is available"

# ----------------------------
# WordPress initialization (only if not already installed)
# ----------------------------
if [ ! -f "$WORKDIR/index.php" ]; then
    echo "[WordPress] Downloading WordPress..."
    curl -o latest.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz -C $WORKDIR --strip-components=1
    rm latest.tar.gz

    echo "[WordPress] Setting permissions..."
    chown -R www-data:www-data $WORKDIR
    find $WORKDIR -type d -exec chmod 755 {} \;
    find $WORKDIR -type f -exec chmod 644 {} \;

    echo "[WordPress] Configuring wp-config.php..."
    wp config create \
        --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --dbcharset="utf8" \
        --dbcollate="utf8_general_ci"

    echo "[WordPress] Installing WordPress..."
    wp core install \
        --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="42 Inception" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL"

    echo "[WordPress] Creating secondary user..."
    wp user create \
        "${WP_SECONDARY_USER}" "${WP_SECONDARY_EMAIL}" \
        --role=editor \
        --user_pass="$(cat "$WP_SECONDARY_PASSWORD")" \
        --allow-root

    echo "[WordPress] WordPress initialization completed"
else
    echo "[WordPress] WordPress already installed, skipping initialization"
fi


# ----------------------------
# Start PHP-FPM
# ----------------------------
exec "$@"
