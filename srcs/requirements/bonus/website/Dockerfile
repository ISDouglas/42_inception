FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app
EXPOSE 80
# COPY . /usr/share/nginx/html
CMD ["python3", "-m", "http.server", "80"]