FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y redis-server && rm -rf /var/lib/apt/lists/*

COPY conf/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 6379

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]