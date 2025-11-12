FROM debian:bookworm-slim

# Install MariaDB server
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Prepare directories and permissions
RUN mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld \
    && chmod 755 /var/lib/mysql

# Copy custom entrypoint script
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# USER mysql
# Expose MariaDB default port
EXPOSE 3306

# Run entrypoint when the container starts
ENTRYPOINT ["/entrypoint.sh"]

# maradb without nginx as PID 1 in foreground mode
#CMD ["mysqld_safe", "--user=mysql",  "--datadir=/var/lib/mysql"]