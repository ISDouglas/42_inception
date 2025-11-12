#!/bin/sh
set -e

if [ "$(stat -c '%U' /var/lib/mysql)" != "mysql" ]; then
    echo "[MariaDB] Fixing directory ownership..."
    chown -R mysql:mysql /var/lib/mysql || true
fi

# Read passwords from Docker secrets
DB_PASSWORD=$(cat /run/secrets/db_pw)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_pw)

# ----------------------------
# Check required environment variables
# ----------------------------
: "${DB_NAME:?Database name not defined}"
: "${DB_USER:?Database user not defined}"
: "${DB_PASSWORD:?Password file not defined}"
: "${DB_ROOT_PASSWORD:?Root password file not defined}"


# ----------------------------
# Initialize database (first launch only)
# ----------------------------
FLAG_FILE="/var/lib/mysql/.is_initialized"
if [ ! -f "$FLAG_FILE" ]; then
    echo "[MariaDB] Initializing database..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null 2>&1

    echo "[MariaDB] Starting temporary database..."
    mysqld_safe --skip-networking --datadir=/var/lib/mysql &
    pid="$!"

    echo "[MariaDB] Waiting for MariaDB to start..."
    for i in {1..30}; do
        if mysqladmin ping --silent >/dev/null 2>&1; then
            echo "[MariaDB] MariaDB is ready."
            break
        fi
        echo "[MariaDB] Waiting... ($i)"
        sleep 1
    done

    echo "[MariaDB] Setting up database and users..."
    mysql -uroot  <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    echo "[MariaDB] Stopping temporary database..."
    mysqladmin -uroot -p"${DB_ROOT_PASSWORD}" shutdown >/dev/null 2>&1 || kill "$pid"
    wait "$pid" 2>/dev/null || true

    echo "[MariaDB] Initialization completed."
    touch "$FLAG_FILE"
else
    echo "[MariaDB] Already initialized. Skipping setup."
fi

echo "[MariaDB] Starting MariaDB server..."
#exec "$@"
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql