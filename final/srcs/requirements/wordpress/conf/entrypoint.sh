#!/bin/bash
set -e
set -o pipefail
set -x  # Uncomment for debugging

# -------------------------------------
# Set working directory
# -------------------------------------
WP_PATH=/var/www/html
WORKDIR=$WP_PATH

# -------------------------------------
# Add domain to /etc/hosts
# -------------------------------------
echo "127.0.0.1 ${DOMAIN_NAME}" >> /etc/hosts
echo "127.0.0.1 www.${DOMAIN_NAME}" >> /etc/hosts

# -------------------------------------
# Read secrets
# -------------------------------------
DB_PASSWORD=$(cat /run/secrets/db_pw)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_pw)
WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/credentials_pw)
WP_SECONDARY_PASSWORD=$(cat /run/secrets/credentials_second_pw)

# -------------------------------------
# Check required environment variables
# -------------------------------------
: "${DB_HOST:?DB host not defined}"
: "${DB_NAME:?DB name not defined}"
: "${DB_USER:?DB user not defined}"
: "${DB_PASSWORD:?DB password file not defined}"
: "${DB_ROOT_PASSWORD:?DB root password file not defined}"
: "${WORDPRESS_ADMIN_USER:?WP admin user not defined}"
: "${WORDPRESS_ADMIN_PASSWORD:?WP admin password file not defined}"
: "${WORDPRESS_ADMIN_EMAIL:?WP admin email not defined}"
: "${WP_SECONDARY_USER:?Secondary user not defined}"
: "${WP_SECONDARY_PASSWORD:?Secondary user password file not defined}"
: "${WP_SECONDARY_EMAIL:?Secondary email not defined}"

# -------------------------------------
# Wait for MariaDB to be available
# -------------------------------------
echo "[WordPress] Waiting for database $DB_HOST..."
until mysqladmin ping -h mariadb -uroot -p"$DB_ROOT_PASSWORD" --silent; do
    sleep 2
done
echo "[WordPress] Database is available"

# -------------------------------------
# WordPress initialization
# -------------------------------------
if ! wp core is-installed --allow-root --path="$WP_PATH"; then
    echo "[WordPress] WordPress not detected, starting installation..."

    # Download WordPress
    wp core download --allow-root --path="$WP_PATH"

    # Create wp-config.php
    wp config create --allow-root --path="$WP_PATH" \
        --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST" --skip-check

    # Install WordPress core
    wp core install --allow-root --path="$WP_PATH" \
        --url="https://${DOMAIN_NAME}" --title="42 Inception" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" --skip-email

    echo "[WordPress] Creating secondary user..."
    if ! wp user get "$WP_SECONDARY_USER" --allow-root --path="$WP_PATH" > /dev/null 2>&1; then
        wp user create --allow-root --path="$WP_PATH" \
            "$WP_SECONDARY_USER" "$WP_SECONDARY_EMAIL" \
            --role=editor --user_pass="$WP_SECONDARY_PASSWORD"
    fi

    echo "[WordPress] WordPress installation completed."
else
    echo "[WordPress] WordPress already installed, skipping installation"
fi

# -------------------------------------
# Set permissions for Nginx
# -------------------------------------
echo "[WordPress] Setting permissions for Nginx..."
chown -R www-data:www-data "$WP_PATH"
find "$WP_PATH" -type d -exec chmod 755 {} \;
find "$WP_PATH" -type f -exec chmod 644 {} \;

# -------------------------------------
# Start PHP-FPM
# -------------------------------------
#exec "$@"
exec php-fpm8.2 -F

