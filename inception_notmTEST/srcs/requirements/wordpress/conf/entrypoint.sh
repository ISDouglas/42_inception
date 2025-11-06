#!/bin/sh
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    entrypoint.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ilbonnev <ilbonnev@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/10/08 16:44:27 by ilbonnev          #+#    #+#              #
#    Updated: 2025/10/19 16:34:12 by ilbonnev         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

set -eu

: "${DB_HOST:?Variable DB_HOST non définie}"
: "${DB_PORT:?Variable DB_PORT non définie}"
: "${DB_USER:?Variable DB_USER non définie}"
: "${DB_USER_MDP:?Variable DB_USER_MDP non définie}"
: "${WP_USER:?Variable WP_USER non définie}"
: "${WP_USER_MDP:?Variable WP_USER_MDP non définie}"
: "${WP_ROOT:?Variable WP_ROOT non définie}"
: "${DOMAIN_NAME:?Variable DOMAIN_NAME non définie}"

WP_PATH=/var/www/html

echo "[WordPress] En attente de la connexion à MariaDB sur $DB_HOST..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_USER_MDP" -e "SELECT 1;" >/dev/null 2>&1; do
  echo "[WordPress] Connexion échouée. Nouvelle tentative dans 2 secondes..."
  sleep 2
done
echo "[WordPress] Connexion à MariaDB réussie !"

if ! wp core is-installed --allow-root --path="$WP_PATH"; then
  echo "[WordPress] Installation non détectée. Lancement de l'installation..."
  
  wp core download --allow-root --path="$WP_PATH"

  wp config create --allow-root --path="$WP_PATH" \
    --dbname="wordpress" --dbuser="$DB_USER" --dbpass="$DB_USER_MDP" --dbhost="$DB_HOST:$DB_PORT" --skip-check

  wp core install --allow-root --path="$WP_PATH" \
    --url="https://$DOMAIN_NAME" --title="Inception" \
    --admin_user="$WP_ROOT" --admin_password="$WP_ROOT_MDP" --admin_email="$WP_ROOT_MAIL" --skip-email
  
  echo "[WordPress] Installation de base terminée."
else
  echo "[WordPress] Installation existante détectée."
fi

if ! wp user get "$WP_USER" --allow-root --path="$WP_PATH" > /dev/null 2>&1; then
  echo "[WordPress] Création de l'utilisateur secondaire : $WP_USER"
  wp user create --allow-root --path="$WP_PATH" \
    "$WP_USER" "$WP_USER_MAIL" --user_pass="$WP_USER_MDP" --role=editor
else
  echo "[WordPress] L'utilisateur secondaire $WP_USER existe déjà."
fi

echo "[WordPress] Ajustement des permissions pour Nginx..."
chown -R www-data:www-data "$WP_PATH"

echo "[WordPress] Démarrage de PHP-FPM."
exec "$@"
