FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y vsftpd && rm -rf /var/lib/apt/lists/*

COPY conf/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
