#!/bin/bash

ENV_FILE="./srcs/.env"

log_msg() {
  echo "[INIT] $1"
}

log_err() {
  echo "[ERREUR] $1" >&2
  exit 1
}

log_msg "Préparation des dossiers pour les volumes..."

if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
else
  log_err "Fichier .env non trouvé à l'emplacement $ENV_FILE"
fi

if [ -z "${DATA_PATH}" ]; then
  log_err "DATA_PATH n'est pas défini dans $ENV_FILE."
fi

DIRS_TO_CREATE="mariadb wordpress"

for dir in $DIRS_TO_CREATE; do
  TARGET_PATH="${DATA_PATH}/${dir}"
  if [ ! -d "$TARGET_PATH" ]; then
    log_msg "Création du dossier : $TARGET_PATH"
    mkdir -p "$TARGET_PATH"
    chmod 755 "$TARGET_PATH"
  else
    log_msg "Le dossier $TARGET_PATH existe déjà."
  fi
done

log_msg "Préparation des volumes terminée."
