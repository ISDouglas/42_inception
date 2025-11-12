#!/bin/bash
set -e

# setting redis.conf
echo "[Redis] REDIS_PASSWORD=$REDIS_PASSWORD"
#sed -i "s/^# requirepass.*/requirepass $REDIS_PASSWORD/" /etc/redis/redis.conf
#sed -i "s/^bind 127\.0\.0\.1 -::1/# bind 127.0.0.1 -::1/" /etc/redis/redis.conf
#sed -i "s/^protected-mode yes/protected-mode no/" /etc/redis/redis.conf

# start Redis
#exec redis-server /etc/redis/redis.conf
exec redis-server --requirepass "$REDIS_PASSWORD" --bind 0.0.0.0 --protected-mode no

