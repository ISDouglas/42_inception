#!/bin/bash
set -e

DATADIR=/var/lib/mysql
mkdir -p "$DATADIR"
chown -R mysql:mysql "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
  echo "[mariadb] Initialisation du répertoire de données..."
  mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null
fi

echo "[mariadb] Démarrage temporaire pour configuration..."
mysqld_safe --datadir="$DATADIR" &
for i in {1..60}; do
  mariadb-admin ping --silent && break
  sleep 1
done

echo "[mariadb] Configuration de la base et des utilisateurs..."
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_MDP}';" || true
mysql -uroot -p"${DB_ROOT_MDP}" -e "CREATE DATABASE IF NOT EXISTS \`wordpress\`;"
mysql -uroot -p"${DB_ROOT_MDP}" -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_MDP}';"
mysql -uroot -p"${DB_ROOT_MDP}" -e "GRANT ALL PRIVILEGES ON \`wordpress\`.* TO '${DB_USER}'@'%'; FLUSH PRIVILEGES;"

echo "[mariadb] Configuration terminée. Arrêt du serveur temporaire..."
mysqladmin -uroot -p"${DB_ROOT_MDP}" shutdown

echo "[mariadb] Lancement du serveur principal..."
exec "$@"
