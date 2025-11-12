#!/bin/sh
set -e

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
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[MariaDB] Initializing database..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql

    echo "[MariaDB] Starting temporary database..."
    mysqld_safe --skip-networking --datadir=/var/lib/mysql &
    pid="$!"
    sleep 5

    echo "[MariaDB] Setting up database and users..."
    mysql -uroot -e "
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
        FLUSH PRIVILEGES;
    "

    echo "[MariaDB] Stopping temporary database..."
    kill "$pid"
    sleep 3
fi

echo "[MariaDB] Starting MariaDB server..."
exec "$@"
